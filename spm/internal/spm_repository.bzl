load("@bazel_skylib//lib:paths.bzl", "paths")
load("//spm/internal/modulemap_parser:parser.bzl", "parser")
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
    deps = [
%s
    ],
)
"""

def _create_spm_swift_module_decl(ctx, target):
    """Returns the spm_swift_module declaration for this Swift target.
    """
    module_name = target["c99name"]
    deps = target.get("target_dependencies", default = [])
    deps = ["        \":%s\"," % (dep) for dep in deps]
    deps_str = "\n".join(deps)
    return SPM_SWIFT_MODULE_TPL % (module_name, deps_str)

# def _create_spm_clang_module_decl(ctx, target):
#     module_name = target["c99name"]
#     deps = target.get("target_dependencies", default = [])
#     deps = ["        \":%s\"," % (dep) for dep in deps]
#     deps_str = "\n".join(deps)
#     return SPM_CLANG_MODULE_TPL % (module_name, deps_str)

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

def _get_hdr_paths_from_modulemap(ctx, modulemap_path):
    modulemap_str = ctx.read(modulemap_path)
    module_decls, err = parser.parse(modulemap_str)
    if err != None:
        fail("Errors parsing the %s. %s" % (modulemap_path, err))

    # DEBUG BEGIN
    print("*** CHUCK module_decls: ", module_decls)
    # DEBUG END

    # TODO: IMPLEMENT ME!
    return []

def _create_spm_clang_module_decl(ctx, target):
    module_name = target["c99name"]
    module_paths = _list_files_under(ctx, target["path"])

    # If a modulemap was provided, read it.
    # Otherwise, use all of the header files under the "include" directory.
    modulemap_paths = [p for p in module_paths if _is_modulemap_path(p)]
    modulemap_paths_len = len(modulemap_paths)
    if modulemap_paths_len > 1:
        fail("Found more than one module.modulemap file. %" % (modulemap_paths))
    if modulemap_paths_len == 1:
        hdr_paths = _get_hdr_paths_from_modulemap(ctx, modulemap_paths[0])
    else:
        hdr_paths = [p for p in module_paths if _is_include_hdr_path(p)]

    # DEBUG BEGIN
    print("*** CHUCK module_name: ", module_name)
    print("*** CHUCK module_paths: ")
    for idx, item in enumerate(module_paths):
        print("*** CHUCK", idx, ":", item)
    print("*** CHUCK hdr_paths: ", hdr_paths)
    # DEBUG END

    # TODO: IMPLEMENT ME!
    return ""

def _spm_repository_impl(ctx):
    # Download the archive
    ctx.download_and_extract(
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        stripPrefix = ctx.attr.strip_prefix,
    )

    # Generate description for the package.
    describe_result = ctx.execute(["swift", "package", "describe", "--type", "json"])

    pkg_desc = parse_package_description_json(describe_result.stdout)
    targets = library_targets(pkg_desc)

    modules = []
    for target in targets:
        module_type = target["module_type"]
        if module_type == "SwiftTarget":
            module_decl = _create_spm_swift_module_decl(ctx, target)
        elif module_type == "ClangTarget":
            module_decl = _create_spm_clang_module_decl(ctx, target)
        modules.append(module_decl)

    # Template Substitutions
    substitutions = {
        "{spm_repos_name}": ctx.attr.name,
        "{pkg_desc_json}": describe_result.stdout,
        "{spm_modules}": "\n".join(modules),
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
