load("//spm/internal:providers.bzl", "SPMPackageInfo")

def _get_module_info(pkg_info, module_name):
    for module in pkg_info.swift_modules:
        if module.module_name == module_name:
            return module
    for module in pkg_info.clang_modules:
        if module.module_name == module_name:
            return module
    fail("Could not find module with module_name ", module_name)

def _spm_clang_module_files(ctx):
    pass

_attrs = {
    "package": attr.label(
        mandatory = True,
        providers = [[SPMPackageInfo]],
        doc = """\
        A target that outputs an SPMPackageInfo (e.g. spm_pacakge).
        """,
    ),
    "module_name": attr.string(
        mandatory = True,
        doc = """\
        The name of the module in the SPMPackageInfo to select for file exposition.
        """,
    ),
}

spm_clang_module_files = rule(
    implementation = _spm_package_impl,
    attrs = _attrs,
    doc = "Collects the module files built by SPM and bundles them for swift_import.",
)
