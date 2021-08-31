load(":platforms.bzl", "platforms")
load(":swift_toolchains.bzl", "swift_toolchains")
load(":providers.bzl", "SPMBuildInfo", "SPMPlatformInfo")

# MARK: - Macos Toolchain

def _create_spm_platform_info(swift_cpu, swift_os):
    """Creates an `SpmPlatformInfo` from the cpu and OS from the apple fragment.

    Args:
        swift_cpu: A `string` value from an apple fragment `single_arch_cpu`.
        swift_os: A `string` value.

    Returns:
        An instance of `SPMPlatformInfo` provider.
    """
    return SPMPlatformInfo(
        os = platforms.spm_os(swift_os),
        arch = platforms.spm_arch(swift_cpu),
        vendor = platforms.spm_vendor(swift_os),
    )

def _spm_xcode_toolchain(ctx):
    # Apple fragment doc: https://docs.bazel.build/versions/4.0.0/skylark/lib/apple.html
    apple_fragment = ctx.fragments.apple

    # This was heavily inspired by
    # https://github.com/bazelbuild/rules_swift/blob/master/swift/internal/xcode_swift_toolchain.bzl#L638
    cpu = apple_fragment.single_arch_cpu
    platform = apple_fragment.single_arch_platform
    xcode_config = ctx.attr._xcode_config[apple_common.XcodeVersionConfig]
    target_os_version = xcode_config.minimum_os_for_platform_type(
        platform.platform_type,
    )
    target_triple = swift_toolchains.apple_target_triple(cpu, platform, target_os_version)
    sdk_name = swift_toolchains.sdk_name(platform)

    # GH024: Add Linux support.
    exec_os = "macosx"

    spm_build_info = SPMBuildInfo(
        build_tool = ctx.executable._macos_build_tool,
        sdk_name = sdk_name,
        target_triple = target_triple,
        spm_platform_info = _create_spm_platform_info(cpu, exec_os),
    )

    return [spm_build_info]

spm_xcode_toolchain = rule(
    implementation = _spm_xcode_toolchain,
    fragments = ["apple"],
    attrs = {
        "_macos_build_tool": attr.label(
            executable = True,
            cfg = "exec",
            default = "//spm/internal:exec_spm_build",
        ),
        "_xcode_config": attr.label(
            default = configuration_field(
                name = "xcode_config_label",
                fragment = "apple",
            ),
        ),
    },
)
