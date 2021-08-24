load("@build_bazel_rules_swift//swift/internal:actions.bzl", "swift_action_names")
load("@bazel_skylib//lib:types.bzl", "types")

# def _get_action_configs(swift_toolchain_info, action_name = None):
#     pass

# def _get_action_config(swift_toolchain_info, action_name = None, flag = None):
#     for action_config in swift_toolchain_info.action_configs:
#         for configurator in configurators:
#             pass

# def _get_target_triple(swift_toolchain_info):
#     target_flag_action_config = _get_action_config(
#         swift_toolchain_info,
#         action_name = swift_action_names.COMPILE,
#         flag = "-target",
#     )
#     triple = None
#     for configurator in configurators:
#         if not types.is_struct(configurator):
#             continue
#     return

def _get_args_for_action(swift_toolchain_info, action_name):
    args = []
    for action_config in swift_toolchain_info.action_configs:
        if action_name not in action_config.actions:
            continue
        for configurator in action_config.configurators:
            if types.is_function(configurator):
                continue
            args.append(configurator.args)
    return args

def _get_target_triple(swift_toolchain_info):
    args = _get_args_for_action(swift_toolchain_info, swift_action_names.COMPILE)
    for flag_name, flag_value in args:
        if flag_name == "-target":
            return flag_value
    fail("Failed to find the target triple in SwiftToolchainInfo.")

swift_toolchains = struct(
    target_triple = _get_target_triple,
)
