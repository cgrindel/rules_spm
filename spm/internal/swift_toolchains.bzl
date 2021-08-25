load("@build_bazel_rules_swift//swift/internal:actions.bzl", "swift_action_names")
load("@bazel_skylib//lib:types.bzl", "types")

# def _get_args_for_action(swift_toolchain_info, action_name):
#     args = []
#     for action_config in swift_toolchain_info.action_configs:
#         if action_name not in action_config.actions:
#             continue
#         for configurator in action_config.configurators:
#             if types.is_function(configurator):
#                 continue
#             args.append(configurator.args)
#     return args

# def _get_target_triple(swift_toolchain_info):
#     args = _get_args_for_action(swift_toolchain_info, swift_action_names.COMPILE)
#     for flag_name, flag_value in args:
#         if flag_name == "-target":
#             return flag_value
#     fail("Failed to find the target triple in SwiftToolchainInfo.")

def _get_sdk_name(platform):
    return platform.name_in_plist.lower()

def _get_os_name(platform):
    platform_string = str(platform.platform_type)
    if platform_string == "macos":
        platform_string = "macosx"
    return platform_string

# This was copied from https://github.com/bazelbuild/rules_swift/blob/master/swift/internal/xcode_swift_toolchain.bzl#L594.
def _swift_apple_target_triple(cpu, platform, version):
    """Returns a target triple string for an Apple platform.

    Args:
        cpu: The CPU of the target.
        platform: The `apple_platform` value describing the target platform.
        version: The target platform version as a dotted version string.

    Returns:
        A target triple string describing the platform.
    """
    platform_string = str(platform.platform_type)
    if platform_string == "macos":
        platform_string = "macosx"

    environment = ""
    if not platform.is_device:
        environment = "-simulator"

    return "{cpu}-apple-{platform}{version}{environment}".format(
        cpu = cpu,
        environment = environment,
        platform = platform_string,
        version = version,
    )

swift_toolchains = struct(
    # target_triple = _get_target_triple,
    apple_target_triple = _swift_apple_target_triple,
    sdk_name = _get_sdk_name,
    os_name = _get_os_name,
)
