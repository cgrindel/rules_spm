def _spm_package_impl(ctx):
    # output_file = ctx.actions.declare_file("chicken.out")
    build_output_dir = ctx.actions.declare_directory("spm_build_output")
    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        # outputs = [output_file],
        # arguments = [output_file.path],
        outputs = [build_output_dir],
        arguments = [build_output_dir.path],
        # command = "echo Smidgen > \"$1\"",
        # command = "ls -la  > \"$1\"",
        # command = "tree -l  > \"$1\"",
        command = """
        cd external/apple_swift_log
        swift build \
            --verbose \
            --manifest-cache=none \
            --disable-sandbox \
            --show-bin-path \
            --build-path="$1"
        """,
        progress_message = "Building the Swift package using SPM.",
    )

    # return [DefaultInfo(files = depset([output_file]))]
    return [DefaultInfo(files = depset([build_output_dir]))]

_attrs = {
    # "urls": attr.string_list(),
    # "sha256": attr.string(),
    # "strip_prefix" = attr.string(),
    # "deps": attr.label_list(),
    "srcs": attr.label_list(
        allow_files = True,
        mandatory = True,
    ),
}

spm_package = rule(
    implementation = _spm_package_impl,
    attrs = _attrs,
    doc = "Builds the specified Swift package.",
)
