SPM_LABEL_PREFIX = "@cgrindel_rules_spm//spm:"
SPM_TOOLCHAIN_TYPE = SPM_LABEL_PREFIX + "toolchain_type"

# MARK: - Linux Toolchain

def _spm_linux_toolchain(ctx):
    # TODO: Return an SPMBuildInfo.
    pass

spm_linux_toolchain = rule(
    implementation = _spm_linux_toolchain,
    attrs = {},
)

# MARK: - Macos Toolchain

def _spm_xcode_toolchain(ctx):
    # TODO: Return an SPMBuildInfo.
    pass

spm_xcode_toolchain = rule(
    implementation = _spm_xcode_toolchain,
    attrs = {},
)

# MARK: - Declar Toolchains

def declare_toolchains():
    spm_linux_toolchain(
        name = "linux_toolchain_impl",
    )

    native.toolchain(
        name = "linux_toolchain",
        exec_compatible_with = [
            "@platforms//os:linux",
        ],
        toolchain = ":linux_toolchain_impl",
        toolchain_type = SPM_TOOLCHAIN_TYPE,
    )

    spm_xcode_toolchain(
        name = "xcode_toolchain_impl",
    )

    native.toolchain(
        name = "xcode_toolchain",
        exec_compatible_with = [
            "@platforms//os:macos",
        ],
        toolchain = ":xcode_toolchain_impl",
        toolchain_type = SPM_TOOLCHAIN_TYPE,
    )
