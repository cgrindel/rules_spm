SPMPackageInfo = provider(
    doc = "Describes the information about the SPM package.",
    fields = {
        "name": "Name of the Swift package.",
        "swift_modules": "`List` of values returned from `spm_common.create_swift_module`.",
        "clang_modules": "`List` of values returned from `spm_common.create_clang_module`.",
    },
)

# SPMClangModuleInfo = provider(
#     doc = "Describes the information about a clang .",
#     fields = {
#         "module_name": "Module name",
#         "o_files": "`List` of Mach-O files.",
#         "hdrs": "`List` of header files.",
#         "modulemap": "The original module.modulemap.",
#         "all_outputs": "All outputs",
#     },
# )

def create_swift_module(module_name, o_files, swiftdoc, swiftmodule, swiftsourceinfo, hdrs, all_outputs):
    """Creates a value representing the Swift module that is built from a package.

    Args:
        module_name: Name of the Swift module.
        o_files: The Mach-O files that are built by SPM.
        swiftdoc: The .swiftdoc file that is built by SPM.
        swiftmodule: The .swiftmodule file that is built by SPM.
        swiftsourceinfo: The .swiftsourceinfo file that is built by SPM.
        all_outputs: All of the output files that are declared for the module.
    """
    return struct(
        module_name = module_name,
        o_files = o_files,
        swiftdoc = swiftdoc,
        swiftmodule = swiftmodule,
        swiftsourceinfo = swiftsourceinfo,
        hdrs = hdrs,
        all_outputs = all_outputs,
    )

def create_clang_module(module_name, o_files, hdrs, modulemap, all_outputs):
    """Creates a value representing the Clang module that is built from a package.

    Args:
        module_name: Name of the Swift module.
        o_files: The Mach-O files that are built by SPM.
        hdrs: The header files.
        all_outputs: All of the output files that are declared for the module.
    """
    return struct(
        module_name = module_name,
        o_files = o_files,
        hdrs = hdrs,
        modulemap = modulemap,
        all_outputs = all_outputs,
    )

def create_copy_info(src, dest):
    """Creates a value describing a copy operation.

    Args:
        src: The source file.
        dest: The destination file.
    """
    return struct(
        src = src,
        dest = dest,
    )
