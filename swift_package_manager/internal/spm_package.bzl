def _spm_package_impl(ctx):
    pass

_attrs = {
    # "urls": attr.string_list(),
    # "sha256": attr.string(),
    # "strip_prefix" = attr.string(),
    # "deps": attr.label_list(),
}

spm_package = rule(
    implementation = _spm_package_impl,
    attrs = _attrs,
    doc = "Downloads and builds the specified Swift package.",
)
