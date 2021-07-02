def _spm_repository_impl(ctx):
    # Download the archive
    ctx.download_and_extract(
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        stripPrefix = ctx.attr.strip_prefix,
    )

    # Generate description for the package.
    describe_result = ctx.execute(["swift", "package", "describe", "--type", "json"])

    # DEBUG BEGIN
    ctx.file(
        "package_description.json",
        content = describe_result.stdout,
        executable = False,
    )
    # DEBUG END

    # Template Substitutions
    substitutions = {
        "{spm_repos_name}": ctx.attr.name,
        "{pkg_desc_json}": describe_result.stdout,
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
            # TODO: Can we replace this with Label("//swift_package_manager/internal:BUILD.bazel.tpl")?
            default = "@rules_swift_package_manager//swift_package_manager/internal:BUILD.bazel.tpl",
        ),
    },
)
