def _spm_package_impl(ctx):
    output_file = ctx.actions.declare_file("chicken.out")
    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        outputs = [output_file],
        arguments = [output_file.path],
        command = "echo Smidgen > \"$1\"",
        progress_message = "Building the Swift package using SPM.",
    )
    return [DefaultInfo(files = depset([output_file]))]

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
