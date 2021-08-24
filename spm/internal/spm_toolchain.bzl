load(":platforms.bzl", "platforms")
load("@build_bazel_rules_swift//swift:swift.bzl", "SwiftToolchainInfo")

SPM_LABEL_PREFIX = "@cgrindel_rules_spm//spm:"
SPM_TOOLCHAIN_TYPE = SPM_LABEL_PREFIX + "toolchain_type"

SpmBuildInfo = provider(
    doc = "Information about how to invoke the Swift package manager.",
    fields = ["build_tool", "spm_platform_info"],
)

SpmPlatformInfo = provider(
    doc = "SPM designations for the architecture, OS and vendor.",
    fields = ["os", "arch", "vendor"],
)

def _create_spm_platform_info(swift_cpu, swift_os):
    """Creates an `SpmPlatformInfo` from the `cpu` and `system_name` from
    SwiftToolchainInfo.

    Args:
        swift_cpu: A `string` value from `SwiftToolchainInfo.cpu`.
        swift_os: A `string` value from `SwiftToolchainInfo.system_name`.

    Returns:
        An instance of `SpmPlatformInfo` provider.
    """
    return SpmPlatformInfo(
        os = platforms.spm_os(swift_os),
        arch = platforms.spm_arch(swift_cpu),
        vendor = platforms.spm_vendor(swift_os),
    )

def get_spm_build_info(ctx):
    """Returns the `SpmBuildInfo` that has been selected as part of Swift's 
    toolchain evaluation.

    Args:
        ctx: A `ctx` instance.

    Returns:
        An instance of a `SpmBuildInfo`.
    """

    # Swift rules do not support platforms and Bazel toolchains. We will
    # interrogate their SwiftToolchainInfo for cpu/arch and OS.
    swift_toolchain_info = ctx.attr._toolchain[SwiftToolchainInfo]
    return SpmBuildInfo(
        build_tool = ctx.executable._macos_build_tool,
        spm_platform_info = _create_spm_platform_info(
            swift_toolchain_info.cpu,
            swift_toolchain_info.system_name,
        ),
    )
