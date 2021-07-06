SPMPackageInfo = provider(
    doc = "Describes the information about the SPM package.",
    fields = {
        "name": "Name of the Swift package.",
        "modules": "`List` of values returned from `spm_common.create_module`.",
    },
)

def create_module(module_name, o_files, swiftdoc, swiftmodule, swiftsourceinfo, all_files):
    """Creates a value representing the Swift module that is built from a package.

    Args:
        module_name: Name of the Swift module.
        o_files: The Mach-O files that are built by SPM.
        swiftdoc: The .swiftdoc file that is built by SPM.
        swiftmodule: The .swiftmodule file that is built by SPM.
    """
    return struct(
        module_name = module_name,
        o_files = o_files,
        swiftdoc = swiftdoc,
        swiftmodule = swiftmodule,
        swiftsourceinfo = swiftsourceinfo,
        all_files = all_files,
    )
