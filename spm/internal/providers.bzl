SPMPackageInfo = provider(
    doc = "Describes the information about the SPM package.",
    fields = {
        "name": "Name of the Swift package.",
        "swift_modules": "`List` of values returned from `providers.swift_module`.",
        "clang_modules": "`List` of values returned from `providers.clang_module`.",
    },
)

def _create_swift_module(module_name, o_files, swiftdoc, swiftmodule, swiftsourceinfo, hdrs, all_outputs):
    """Creates a value representing the Swift module that is built from a package.

    Args:
        module_name: Name of the Swift module.
        o_files: The Mach-O files that are built by SPM.
        swiftdoc: The .swiftdoc file that is built by SPM.
        swiftmodule: The .swiftmodule file that is built by SPM.
        swiftsourceinfo: The .swiftsourceinfo file that is built by SPM.
        all_outputs: All of the output files that are declared for the module.

    Returns:
        A struct which provides info about a Swift module built by SPM.
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

def _create_clang_module(module_name, o_files, hdrs, modulemap, all_outputs):
    """Creates a value representing the Clang module that is built from a package.

    Args:
        module_name: Name of the Swift module.
        o_files: The Mach-O files that are built by SPM.
        hdrs: The header files.
        all_outputs: All of the output files that are declared for the module.

    Returns:
        A struct which provides info about a clang module build by SPM.
    """
    return struct(
        module_name = module_name,
        o_files = o_files,
        hdrs = hdrs,
        modulemap = modulemap,
        all_outputs = all_outputs,
    )

def _create_copy_info(src, dest):
    """Creates a value describing a copy operation.

    Args:
        src: The source file.
        dest: The destination file.

    Returns:
        A struct describing a copy operation performed during the SPM build.
    """
    return struct(
        src = src,
        dest = dest,
    )

# MARK: - Namespace

providers = struct(
    swift_module = _create_swift_module,
    clang_module = _create_clang_module,
    copy_info = _create_copy_info,
)
