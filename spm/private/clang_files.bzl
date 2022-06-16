load("@bazel_skylib//lib:paths.bzl", "paths")
load("//spm/private/modulemap_parser:declarations.bzl", dts = "declaration_types")
load("//spm/private/modulemap_parser:parser.bzl", modulemap_parser = "parser")
load(":repository_files.bzl", "repository_files")

# Directory names that may include public header files.
_PUBLIC_HDR_DIRNAMES = ["include", "public"]

def _is_include_hdr(path):
    """Determines whether the path is a public header.

    Args:
        path: A path `string` value.

    Returns:
        A `bool` indicating whether the path is a public header.
    """
    _root, ext = paths.split_extension(path)
    if ext != ".h":
        return False
    for dirname in _PUBLIC_HDR_DIRNAMES:
        if (path.find("/%s/" % dirname) > -1) or path.startswith("%s/" % dirname):
            return True
    return False

def _is_public_modulemap(path):
    """Determines whether the specified path is to a public `module.modulemap` file.

    Args:
        path: A path `string`.

    Returns:
        A `bool` indicating whether the path is a public `module.modulemap`
        file.
    """
    basename = paths.basename(path)
    return basename == "module.modulemap"

def _get_hdr_paths_from_modulemap(repository_ctx, modulemap_path):
    """Retrieves the list of headers declared in the specified modulemap file.

    Args:
        repository_ctx: A `repository_ctx` instance.
        modulemap_path: A path `string` to the `module.modulemap` file.

    Returns:
        A `list` of path `string` values.
    """
    modulemap_str = repository_ctx.read(modulemap_path)
    decls, err = modulemap_parser.parse(modulemap_str)
    if err != None:
        fail("Errors parsing the %s. %s" % (modulemap_path, err))

    module_decls = [d for d in decls if d.decl_type == dts.module]
    if len(module_decls) == 0:
        fail("No module declarations were found in %s." % (modulemap_path))

    modulemap_dirname = paths.dirname(modulemap_path)
    hdrs = []
    for module_decl in module_decls:
        for cdecl in module_decl.members:
            if cdecl.decl_type == dts.single_header and not cdecl.private and not cdecl.textual:
                # Resolve the path relative to the modulemap
                hdr_path = paths.join(modulemap_dirname, cdecl.path)
                normalized_hdr_path = paths.normalize(hdr_path)
                hdrs.append(normalized_hdr_path)

    return hdrs

def _identify_files(repository_ctx, root_path):
    paths_list = repository_files.list_files_under(repository_ctx, root_path)

    # hdrs: Public headers
    # srcs: Private headers and source files.
    # others: Uncategorized
    # modulemap: Public modulemap
    hdrs = []
    srcs = []
    others = []
    modulemap = None
    for path in paths_list:
        _root, ext = paths.split_extension(path)
        if ext == ".h":
            if _is_include_hdr(path):
                hdrs.append(path)
            else:
                srcs.append(path)
        elif ext == ".c":
            srcs.append(path)
        elif ext == ".modulemap" and _is_public_modulemap(path):
            if modulemap != None:
                fail("Found multiple modulemap files. {first} {second}".format(
                    first = modulemap,
                    second = path,
                ))
            modulemap = path
        else:
            others.append(path)

    # If we found a public modulemap, get the headers from there. This
    # overrides any hdrs that we found by inspection.
    if modulemap != None:
        hdrs = _get_hdr_paths_from_modulemap(repository_ctx, modulemap)

    return struct(
        hdrs = hdrs,
        srcs = srcs,
        modulemap = modulemap,
        others = others,
    )

clang_files = struct(
    is_include_hdr = _is_include_hdr,
    is_public_modulemap = _is_public_modulemap,
    identify_files = _identify_files,
    get_hdr_paths_from_modulemap = _get_hdr_paths_from_modulemap,
)
