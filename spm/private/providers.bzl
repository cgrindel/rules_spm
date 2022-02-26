"""Definition for providers."""

# MARK: - SPM Toolchain/Build Providers

SPMToolchainInfo = provider(
    doc = "Information about how to invoke tools like the Swift package manager.",
    fields = {
        "spm_configuration": """\
The SPM build configuration as a `string`. Values: `release` or `debug`\
""",
        "spm_platform_info": "An `SpmPlatformInfo` describing the target platform.",
        "target_triple": "A string representing the target platform as a triple.",
        "tool_configs": """\
A `dict` of configuration structs where the key is an action name \
(`action_names`) and the value is a `struct` as returned by \
`actions.tool_config()`.\
""",
    },
)

SPMPlatformInfo = provider(
    doc = "SPM designations for the architecture, OS and vendor.",
    fields = {
        "abi": "The abi destination as understood by SPM.",
        "arch": "The architecture designation as understood by SPM.",
        "os": "The OS designation as understood by SPM.",
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
        "clang_modules": "A `list` of values returned from `providers.clang_module`.",
        "name": "Name of the Swift package.",
        "swift_binaries": "A `list` of values returned from `providers.swift_binary`.",
        "swift_modules": "A `list` of values returned from `providers.swift_module`.",
        "system_library_modules": "`List` of values returned from `providers.system_library_module`.",
    },
)

def _create_swift_binary(name, executable = None, all_outputs = []):
    """Creates a value representing a Swift binary that is built from a package.

    Args:
        name: Name of the Swift binary.
        executable: The executable.
        all_outputs: All of the output files that are declared for the module.

    Returns:
        A struct which provides info about a Swift binary built by SPM.
    """
    return struct(
        name = name,
        executable = executable,
        all_outputs = all_outputs,
    )

def _create_swift_module(
        module_name,
        o_files = [],
        swiftdoc = None,
        swiftmodule = None,
        swiftsourceinfo = None,
        executable = None,
        all_outputs = []):
    """Creates a value representing the Swift module that is built from a package.

    Args:
        module_name: Name of the Swift module.
        o_files: The Mach-O files that are built by SPM.
        swiftdoc: The .swiftdoc file that is built by SPM.
        swiftmodule: The .swiftmodule file that is built by SPM.
        swiftsourceinfo: The .swiftsourceinfo file that is built by SPM.
        executable: The executable if the target is executable.
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
        all_outputs = all_outputs,
        executable = executable,
    )

def _create_clang_module(
        module_name,
        o_files = [],
        hdrs = [],
        modulemap = None,
        all_outputs = []):
    """Creates a value representing the Clang module that is built from a package.

    Args:
        module_name: Name of the Swift module.
        o_files: The Mach-O files that are built by SPM.
        hdrs: The header files.
        modulemap: A modulemap struct.
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

def _create_system_library_module(
        module_name,
        c_files = [],
        hdrs = [],
        modulemap = None,
        all_outputs = []):
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
    clang_module = _create_clang_module,
    copy_info = _create_copy_info,
    swift_binary = _create_swift_binary,
    swift_module = _create_swift_module,
    system_library_module = _create_system_library_module,
)
