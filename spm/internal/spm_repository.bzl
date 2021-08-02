load("@bazel_skylib//lib:paths.bzl", "paths")
load("//spm/internal/modulemap_parser:parser.bzl", "parser")
load("//spm/internal/modulemap_parser:declarations.bzl", dts = "declaration_types")
load(
    "//spm/internal:package_description.bzl",
    "library_targets",
    "parse_package_description_json",
)

SPM_SWIFT_MODULE_TPL = """
spm_swift_module(
    name = "%s",
    package = ":build",
    deps = [
%s
    ],
)
"""

SPM_CLANG_MODULE_TPL = """
spm_clang_module(
    name = "%s",
    package = ":build",
    hdrs = [
%s
    ],
    deps = [
%s
    ],
)
"""

def _create_deps_str(target):
    deps = target.get("target_dependencies", default = [])
    deps = ["        \":%s\"," % (dep) for dep in deps]
    return "\n".join(deps)

def _create_hdrs_str(hdr_paths):
    hdrs = ["        \"%s\"," % (p) for p in hdr_paths]
    return "\n".join(hdrs)

def _create_clang_module_headers_entry(target_name, hdr_paths):
    entry_tpl = """\
        "%s": [
    %s
        ],"""
    hdrs_str = _create_hdrs_str(hdr_paths)
    return entry_tpl % (target_name, hdrs_str)

def _create_clang_module_headers(hdrs_dict):
    entries = [_create_clang_module_headers_entry(k, hdrs_dict[k]) for k in hdrs_dict]
    return "\n".join(entries)

def _create_spm_swift_module_decl(ctx, target):
    """Returns the spm_swift_module declaration for this Swift target.
    """
    module_name = target["c99name"]
    deps_str = _create_deps_str(target)
    return SPM_SWIFT_MODULE_TPL % (module_name, deps_str)

def _list_files_under(ctx, path):
    exec_result = ctx.execute(
        ["find", path],
        quiet = True,
    )
    if exec_result.return_code != 0:
        fail("Failed to list files in %s. stderr:\n%s" % (path, exec_result.stderr))
    paths = exec_result.stdout.splitlines()
    return paths

def _is_modulemap_path(path):
    basename = paths.basename(path)
    dirname = paths.basename(paths.dirname(path))
    return dirname == "include" and basename == "module.modulemap"

def _is_include_hdr_path(path):
    root, ext = paths.split_extension(path)
    dirname = paths.basename(paths.dirname(path))
    return dirname == "include" and ext == ".h"

def _get_hdr_paths_from_modulemap(ctx, module_paths, modulemap_path):
    modulemap_str = ctx.read(modulemap_path)
    decls, err = parser.parse(modulemap_str)
    if err != None:
        fail("Errors parsing the %s. %s" % (modulemap_path, err))

    module_decls = [d for d in decls if d.decl_type == dts.module]
    module_decls_len = len(module_decls)
    if module_decls_len == 0:
        fail("No module declarations were found in %s." % (modulemap_path))
    if module_decls_len > 1:
        fail("Expected a single module definition but found %s." % (module_decls_len))
    module_decl = module_decls[0]

    modulemap_dirname = paths.dirname(modulemap_path)
    hdrs = []
    for cdecl in module_decl.members:
        if cdecl.decl_type == dts.single_header and not cdecl.private and not cdecl.textual:
            # Resolve the path relative to the modulemap
            hdr_path = paths.join(modulemap_dirname, cdecl.path)
            normalized_hdr_path = paths.normalize(hdr_path)
            hdrs.append(normalized_hdr_path)

    return hdrs

def _create_spm_clang_module_decl(ctx, target):
    module_name = target["c99name"]
    module_paths = _list_files_under(ctx, target["path"])
    custom_hdrs = []

    modulemap_paths = [p for p in module_paths if _is_modulemap_path(p)]
    modulemap_paths_len = len(modulemap_paths)
    if modulemap_paths_len > 1:
        fail("Found more than one module.modulemap file. %" % (modulemap_paths))

    # If a modulemap was provided, read it for header info.
    # Otherwise, use all of the header files under the "include" directory.
    if modulemap_paths_len == 1:
        hdr_paths = _get_hdr_paths_from_modulemap(ctx, module_paths, modulemap_paths[0])
        custom_hdrs = hdr_paths
    else:
        hdr_paths = [p for p in module_paths if _is_include_hdr_path(p)]

    deps_str = _create_deps_str(target)
    hdrs_str = _create_hdrs_str(hdr_paths)

    return SPM_CLANG_MODULE_TPL % (module_name, hdrs_str, deps_str), custom_hdrs

def _spm_repository_impl(ctx):
    # Download the archive
    ctx.download_and_extract(
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        stripPrefix = ctx.attr.strip_prefix,
    )

    # Resolve/fetch the dependencies and cache them in the spm_cache directory.
    resolve_result = ctx.execute(["swift", "package", "resolve", "--build-path", "spm_build"])
    if resolve_result.return_code != 0:
        fail("Resolution of SPM packages for %s failed.\n%s" % (ctx.attr.name, resolve_result.stderr))

    # Generate description for the package.
    describe_result = ctx.execute(["swift", "package", "describe", "--type", "json"])

    pkg_desc = parse_package_description_json(describe_result.stdout)
    targets = library_targets(pkg_desc)

    custom_hdrs_dict = dict()
    modules = []
    for target in targets:
        module_type = target["module_type"]
        if module_type == "SwiftTarget":
            module_decl = _create_spm_swift_module_decl(ctx, target)
        elif module_type == "ClangTarget":
            module_decl, custom_hdrs = _create_spm_clang_module_decl(ctx, target)
            if len(custom_hdrs) > 0:
                target_name = target["name"]
                custom_hdrs_dict[target_name] = custom_hdrs
        modules.append(module_decl)

    # Template Substitutions
    substitutions = {
        "{spm_repos_name}": ctx.attr.name,
        "{pkg_desc_json}": describe_result.stdout,
        "{spm_modules}": "\n".join(modules),
        "{clang_module_headers}": _create_clang_module_headers(custom_hdrs_dict),
    }

    # Write BUILD.bazel file.
    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
        substitutions = substitutions,
        executable = False,
    )

spm_repository = repository_rule(
    implementation = _spm_repository_impl,
    attrs = {
        "sha256": attr.string(),
        "strip_prefix": attr.string(),
        "urls": attr.string_list(
            mandatory = True,
            allow_empty = False,
            doc = "The URLs to use to download the repository.",
        ),
        "_build_tpl": attr.label(
            default = "//spm/internal:BUILD.bazel.tpl",
        ),
    },
)
