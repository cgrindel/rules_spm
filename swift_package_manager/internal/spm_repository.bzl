def _spm_repository_impl(ctx):
    # Download the archive
    ctx.download_and_extract(
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        stripPrefix = ctx.attr.strip_prefix,
    )

    # Template Substitutions
    substitutions = {
        "{spm_repos_name}": ctx.attr.name,
    }

    # Write BUILD.bazel file.
    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
        substitutions = substitutions,
        executable = False,
    )

    # Generate description for the package.
    describe_result = ctx.execute(["swift", "package", "describe", "--type", "json"])
    ctx.file(
        "package_description.json",
        content = describe_result.stdout,
        executable = False,
    )

    # # Generate description for the package.
    # description_json = ctx.actions.declare_file("package_description.json")
    # ctx.actions.run_shell(
    #     inputs = ctx.files.srcs,
    #     outputs = [description_json],
    #     arguments = [ctx.attr.package_path, description_json.path],
    #     command = """
    #     swift package describe \
    #       --manifest-cache none \
    #       --disable-sandbox \
    #       --type json \
    #       --package-path $1 \
    #       > $2
    #     """,
    #     progress_message = "Describe Swift package (%s) using SPM." % (ctx.attr.package_path),
    # )

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
            default = "@rules_swift_package_manager//swift_package_manager/internal:BUILD.bazel.tpl",
        ),
    },
)
