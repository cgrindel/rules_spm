def _spm_package_impl():
    pass

_attrs = {}

spm_package = rule(
    implementation = _spm_package_impl,
    attrs = _attrs,
    doc = "Downloads and builds the specified Swift package.",
)
