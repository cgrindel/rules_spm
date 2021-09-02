# MARK: - SPM Toolchain/Build Providers

SPMBuildInfo = provider(
    doc = "Information about how to invoke the Swift package manager.",
    fields = {
        "build_tool": "The executable that will be used to build the Swift package.",
        "sdk_name": "A string representing the name of the SDK",
        "target_triple": "A string representing the target platform as a triple.",
        "spm_platform_info": "An `SpmPlatformInfo` describing the target platform.",
        "swift_executable": "The path for the `swift` executable."
    },
)

SPMPlatformInfo = provider(
    doc = "SPM designations for the architecture, OS and vendor.",
    fields = {
        "os": "The OS designation as understood by SPM.",
        "arch": "The architecture designation as understood by SPM.",
        "vendor": "The vendor designation as understood by SPM.",
    },
)

# MARK: - SPM Package Providers

SPMPackagesInfo = provider(
    doc = "Provides information about the dependent SPM packages.",
    fields = {
        "packages": "A `list` of SPMPackageInfo representing the dependent packages.",
    },
)

SPMPackageInfo = provider(
    doc = "Describes the information about an SPM package.",
    fields = {
        "name": "Name of the Swift package.",
        "swift_modules": "A `list` of values returned from `providers.swift_module`.",
        "clang_modules": "A `list` of values returned from `providers.clang_module`.",
        "system_library_modules": "`List` of values returned from `providers.system_library_module`.",
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

def _create_system_library_module(module_name, c_files, hdrs, modulemap, all_outputs):
    """Creates a value representing the system library module that is built from a package.

    Args:
        module_name: Name of the Swift module.
        c_files: The C source files that are part of the system library
                 definition.
        hdrs: The header files.
        modulemap: The module.modulemap file for the system library module.
        all_outputs: All of the output files that are declared for the module.

    Returns:
        A struct which provides info about a system library module.
    """
    return struct(
        module_name = module_name,
        c_files = c_files,
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
    system_library_module = _create_system_library_module,
    copy_info = _create_copy_info,
)
