"""Definition for spm_xcode_toolchain rule."""

load(":actions.bzl", "action_names", "actions")
load(":platforms.bzl", "platforms")
load(":providers.bzl", "SPMPlatformInfo", "SPMToolchainInfo")
load(":swift_toolchains.bzl", "swift_toolchains")

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
        abi = None,
    )

def _create_build_tool_config(ctx, xcode_config, target_triple, spm_configuration, sdk_name = None):
    swift_worker = ctx.executable._swift_worker

    args = [
        "--worker",
        swift_worker,
    ]
    if sdk_name:
        args.extend(["--sdk_name", sdk_name])

    for spm_utility in ctx.files._spm_utilities:
        args.extend(["--spm_utility", spm_utility])

    args.extend(["-Xspm", "--disable-sandbox"])
    args.extend(["-Xspm", "--configuration", "-Xspm", spm_configuration])

    if _is_xcode_at_least_version(xcode_config, "12.5"):
        args.extend(["-Xspm", "--manifest-cache", "-Xspm", "none"])
        args.extend(["-Xspm", "--disable-repository-cache"])

    args.extend(["-Xswiftc", "-target", "-Xswiftc", target_triple])
    args.extend(["-Xcc", "-target", "-Xcc", target_triple])

    env = apple_common.apple_host_system_env(xcode_config)
    return actions.tool_config(
        executable = ctx.executable._build_tool,
        additional_tools = [swift_worker] + ctx.files._spm_utilities,
        args = args,
        env = env,
        execution_requirements = xcode_config.execution_info(),
    )

# This was heavily inspired by
# https://github.com/bazelbuild/rules_swift/blob/master/swift/internal/xcode_swift_toolchain.bzl#L573
def _is_xcode_at_least_version(xcode_config, desired_version):
    """Returns True if we are building with at least the given Xcode version.

    Args:
        xcode_config: The `apple_common.XcodeVersionConfig` provider.
        desired_version: The minimum desired Xcode version, as a dotted version
            string.

    Returns:
        True if the current target is being built with a version of Xcode at
        least as high as the given version.
    """
    current_version = xcode_config.xcode_version()
    if not current_version:
        fail("Could not determine Xcode version at all. This likely means " +
             "Xcode isn't available; if you think this is a mistake, please " +
             "file an issue.")

    desired_version_value = apple_common.dotted_version(desired_version)
    return current_version >= desired_version_value

# This was heavily inspired by
# https://github.com/bazelbuild/rules_swift/blob/master/swift/internal/xcode_swift_toolchain.bzl#L638
def _spm_xcode_toolchain(ctx):
    # Apple fragment doc: https://docs.bazel.build/versions/4.0.0/skylark/lib/apple.html
    apple_fragment = ctx.fragments.apple

    cpu = apple_fragment.single_arch_cpu
    platform = apple_fragment.single_arch_platform
    xcode_config = ctx.attr._xcode_config[apple_common.XcodeVersionConfig]

    target_os_version = xcode_config.minimum_os_for_platform_type(
        platform.platform_type,
    )
    target_triple = swift_toolchains.apple_target_triple(cpu, platform, target_os_version)
    sdk_name = swift_toolchains.sdk_name(platform)

    # GH073: Can be `release` or `debug`. Provide a means for configuring this value.
    spm_configuration = "release"

    exec_os = "macosx"
    tool_configs = {
        action_names.BUILD: _create_build_tool_config(
            ctx = ctx,
            xcode_config = xcode_config,
            target_triple = target_triple,
            spm_configuration = spm_configuration,
            sdk_name = sdk_name,
        ),
    }

    spm_toolchain_info = SPMToolchainInfo(
        spm_configuration = spm_configuration,
        target_triple = target_triple,
        spm_platform_info = _create_spm_platform_info(cpu, exec_os),
        tool_configs = tool_configs,
    )

    return [spm_toolchain_info]

spm_xcode_toolchain = rule(
    implementation = _spm_xcode_toolchain,
    fragments = ["apple"],
    attrs = {
        "_build_tool": attr.label(
            executable = True,
            cfg = "exec",
            default = "//spm/private:exec_spm_build",
        ),
        "_spm_utilities": attr.label(
            cfg = "host",
            allow_files = True,
            default = Label(
                "@cgrindel_rules_spm_local_config//spm_utilities:all_utilities",
            ),
            doc = """\
The location for the utilities that are required by SPM.\
""",
        ),
        "_swift_worker": attr.label(
            cfg = "host",
            allow_files = True,
            default = Label(
                "@build_bazel_rules_swift//tools/worker",
            ),
            doc = """\
An executable that wraps Swift compiler invocations and also provides support
for incremental compilation using a persistent mode.
""",
            executable = True,
        ),
        "_xcode_config": attr.label(
            default = configuration_field(
                name = "xcode_config_label",
                fragment = "apple",
            ),
        ),
    },
    doc = "Provides toolchain information for SPM builds using Xcode.",
)
