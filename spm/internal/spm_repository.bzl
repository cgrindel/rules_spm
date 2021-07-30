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

def _create_spm_clang_module_decl(ctx, target):
    module_name = target["c99name"]
    deps = target.get("target_dependencies", default = [])
    deps = ["        \":%s\"," % (dep) for dep in deps]
    deps_str = "\n".join(deps)
    return SPM_CLANG_MODULE_TPL % (module_name, deps_str)

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
