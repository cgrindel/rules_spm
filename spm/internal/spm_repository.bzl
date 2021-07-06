load(
    "//spm/internal:package_description.bzl",
    "exported_targets",
    "parse_package_descrition_json",
)

SPM_MODULE_TPL = """
spm_module(
    name = "%s",
    package = ":build",
)
"""

def _spm_repository_impl(ctx):
    # Download the archive
    ctx.download_and_extract(
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        stripPrefix = ctx.attr.strip_prefix,
    )

    # Generate description for the package.
    describe_result = ctx.execute(["swift", "package", "describe", "--type", "json"])

    pkg_desc = parse_package_descrition_json(describe_result.stdout)
    targets = exported_targets(pkg_desc)

    modules = [SPM_MODULE_TPL % (target["c99name"]) for target in targets]

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
            # GH003: Can we replace this with Label("//spm/internal:BUILD.bazel.tpl")?
            default = "@cgrindel_rules_spm//spm/internal:BUILD.bazel.tpl",
        ),
    },
)
