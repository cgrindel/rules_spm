SPMPackageInfo = provider(
    doc = "Describes the information about the SPM package.",
    fields = {
        "name": "Name of the Swift package.",
        "swift_modules": "`List` of values returned from `spm_common.create_swift_module`.",
        "clang_modules": "`List` of values returned from `spm_common.create_clang_module`.",
    },
)

def create_swift_module(module_name, o_files, swiftdoc, swiftmodule, swiftsourceinfo, all_files):
    """Creates a value representing the Swift module that is built from a package.

    Args:
        module_name: Name of the Swift module.
        o_files: The Mach-O files that are built by SPM.
        swiftdoc: The .swiftdoc file that is built by SPM.
        swiftmodule: The .swiftmodule file that is built by SPM.
        swiftsourceinfo: The .swiftsourceinfo file that is built by SPM.
        all_files: All of the output files that are declared for the module.
    """
    return struct(
        module_name = module_name,
        o_files = o_files,
        swiftdoc = swiftdoc,
        swiftmodule = swiftmodule,
        swiftsourceinfo = swiftsourceinfo,
        all_files = all_files,
    )

def create_clang_module(module_name, o_files, all_files):
    """Creates a value representing the Clang module that is built from a package.

    Args:
        module_name: Name of the Swift module.
        o_files: The Mach-O files that are built by SPM.
        all_files: All of the output files that are declared for the module.
    """
    return struct(
        module_name = module_name,
        o_files = o_files,
        all_files = all_files,
    )
