load("//swift_package_manager/internal:providers.bzl", "SPMPackageInfo")

def _get_module_info(pkg_info, module_name):
    for module in pkg_info.modules:
        if module.module_name == module_name:
            return module
    fail("Could not find module with module_name ", module_name)

def _spm_filegroup_impl(ctx):
    pkg_info = ctx.attr.package[SPMPackageInfo]

    module_name = ctx.attr.module_name
    module_info = _get_module_info(pkg_info, module_name)

    output = []
    file_type = ctx.attr.file_type
    if file_type == "o_files":
        output = module_info.o_files
    elif file_type == "swiftdoc":
        output = [module_info.swiftdoc]
    elif file_type == "swiftmodule":
        output = [module_info.swiftmodule]
    elif file_type == "swiftsourceinfo":
        output = [module_info.swiftsourceinfo]
    elif file_type == "all":
        output = module_info.all_files
    else:
        fail("Unrecognized file type: ", file_type)

    return [DefaultInfo(files = depset(output))]

spm_filegroup = rule(
    _spm_filegroup_impl,
    attrs = {
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
        "file_type": attr.string(
            mandatory = True,
            values = ["o_files", "swiftdoc", "swiftmodule", "swiftsourceinfo", "all"],
            doc = """\
            The type of file to expose about the module.
            """,
        ),
    },
    doc = """\
    Exposes the specified type of file(s) from a rule that outputs an SPMPackageInfo (e.g. 
    spm_package).
    """,
)
# o_files = o_files,
# swiftdoc = swiftdoc,
# swiftmodule = swiftmodule,
# swiftsourceinfo = swiftsourceinfo,
# all_files = all_files,
