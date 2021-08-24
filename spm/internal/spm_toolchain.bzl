load(":platforms.bzl", "platforms")
load("@build_bazel_rules_swift//swift:swift.bzl", "SwiftToolchainInfo")

SPM_LABEL_PREFIX = "@cgrindel_rules_spm//spm:"
SPM_TOOLCHAIN_TYPE = SPM_LABEL_PREFIX + "toolchain_type"

SpmBuildInfo = provider(
    doc = "Information about how to invoke the Swift package manager.",
    # fields = ["build_tool", "bzl_platform_info", "spm_platform_info"],
    # fields = ["build_tool", "swift_toolchain_info", "spm_platform_info"],
    fields = ["build_tool", "spm_platform_info"],
)

# BzlPlatformInfo = provider(
#     doc = "Bazel designations for the architecture and OS.",
#     fields = ["os", "arch"],
# )

SpmPlatformInfo = provider(
    doc = "SPM designations for the architecture, OS and vendor.",
    fields = ["os", "arch", "vendor"],
)

# def _spm_toolchain_impl(ctx):
#     toolchain_info = platform_common.ToolchainInfo(
#         spm_build_info = SpmBuildInfo(
#             build_tool = ctx.executable.build_tool,
#             # bzl_platform_info = BzlPlatformInfo(
#             #     os = ctx.attr.bzl_os,
#             #     arch = ctx.attr.bzl_arch,
#             # ),
#             # swift_toolchain_info =
#             spm_platform_info = SpmPlatformInfo(
#                 os = ctx.attr.spm_os,
#                 arch = ctx.attr.spm_arch,
#                 vendor = ctx.attr.spm_vendor,
#             ),
#         ),
#     )
#     return [toolchain_info]

# spm_toolchain = rule(
#     implementation = _spm_toolchain_impl,
#     attrs = {
#         "build_tool": attr.label(
#             executable = True,
#             cfg = "exec",
#         ),
#         "bzl_os": attr.string(
#             doc = "The Bazel designation for the OS.",
#         ),
#         "bzl_arch": attr.string(
#             doc = "The Bazel designation for the architecture.",
#         ),
#         "spm_os": attr.string(
#             doc = "The SPM designation for the OS.",
#         ),
#         "spm_arch": attr.string(
#             doc = "The SPM designation for the architecture.",
#         ),
#         "spm_vendor": attr.string(
#             doc = "The SPM designation for the vendor.",
#         ),
#     },
#     doc = "Defines an SPM toolchain implementation.",
# )

def declare_toolchains():
    """Macro that defines the supported SPM toolchains."""
    # for bzl_os, bzl_arch in SUPPORTED_BZL_PLATFORMS:
    #     impl_name = platforms.toolchain_impl_name(bzl_os, bzl_arch)
    #     spm_os = platforms.spm_os(bzl_os)
    #     spm_arch = platforms.spm_arch(bzl_arch)
    #     spm_vendor = platforms.spm_vendor(bzl_os)
    #     spm_toolchain(
    #         name = impl_name,
    #         build_tool = "//spm/internal:exec_spm_build",
    #         bzl_os = bzl_os,
    #         bzl_arch = bzl_arch,
    #         spm_os = spm_os,
    #         spm_arch = spm_arch,
    #         spm_vendor = spm_vendor,
    #     )

    #     toolchain_name = platforms.toolchain_name(bzl_os, bzl_arch)
    #     native.toolchain(
    #         name = toolchain_name,
    #         exec_compatible_with = [
    #             # GH024: Add Linux support.
    #             "@platforms//os:macos",
    #             # TODO: Support x86_64 and arm64
    #             "@platforms//cpu:x86_64",
    #         ],
    #         target_compatible_with = [
    #             "@platforms//os:" + bzl_os,
    #             "@platforms//cpu:" + bzl_arch,
    #         ],
    #         toolchain = ":" + impl_name,
    #         toolchain_type = SPM_TOOLCHAIN_TYPE,
    #     )
    pass

def _create_spm_platform_info(swift_cpu, swift_os):
    return SpmPlatformInfo(
        os = platforms.spm_os(swift_os),
        arch = platforms.spm_arch(swift_cpu),
        vendor = platforms.spm_vendor(swift_os),
    )

def get_spm_build_info(ctx):
    """Returns the `SpmBuildInfo` that has been selected as part of the 
    toolchain evaluation.

    Args:
        ctx: A `ctx` instance.

    Returns:
        An instance of a `SpmBuildInfo`.
    """

    # # DEBUG BEGIN
    # apple_fragment = ctx.fragments.apple
    # cpu = apple_fragment.single_arch_cpu
    # platform = apple_fragment.single_arch_platform
    # print("*** CHUCK cpu: ", cpu)
    # print("*** CHUCK platform: ", platform)

    # # DEBUG END
    # return ctx.toolchains[SPM_TOOLCHAIN_TYPE].spm_build_info

    # Swift rules do not support platforms and Bazel toolchains. We will
    # interrogate their SwiftToolchainInfo for cpu/arch and OS.
    swift_toolchain_info = ctx.attr._toolchain[SwiftToolchainInfo]
    return SpmBuildInfo(
        # build_tool = Label("//spm/internal:exec_spm_build"),
        build_tool = ctx.executable._macos_build_tool,
        # swift_toolchain_info = swift_toolchain_info,
        spm_platform_info = _create_spm_platform_info(
            swift_toolchain_info.cpu,
            swift_toolchain_info.system_name,
        ),
    )
