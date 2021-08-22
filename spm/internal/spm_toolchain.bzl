load(":platforms.bzl", "SUPPORTED_BZL_PLATFORMS", "platforms")

SPM_TOOLCHAIN_TYPE = "@cgrindel_rules_spm//spm:toolchain_type"

SpmBuildInfo = provider(
    doc = "Information about how to invoke the Swift package manager.",
    fields = ["build_tool", "bzl_platform_info", "spm_platform_info"],
)

BzlPlatformInfo = provider(
    doc = "Bazel designations for the architecture and OS.",
    fields = ["os", "arch"],
)

SpmPlatformInfo = provider(
    doc = "SPM designations for the architecture, OS and vendor.",
    fields = ["os", "arch", "vendor"],
)

def _spm_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        spm_build_info = SpmBuildInfo(
            build_tool = ctx.executable.build_tool,
            bzl_platform_info = BzlPlatformInfo(
                os = ctx.attr.bzl_os,
                arch = ctx.attr.bzl_arch,
            ),
            spm_platform_info = SpmPlatformInfo(
                os = ctx.attr.spm_os,
                arch = ctx.attr.spm_arch,
                vendor = ctx.attr.spm_vendor,
            ),
        ),
    )
    return [toolchain_info]

spm_toolchain = rule(
    implementation = _spm_toolchain_impl,
    attrs = {
        "build_tool": attr.label(
            executable = True,
            cfg = "exec",
        ),
        "bzl_os": attr.string(
            doc = "The Bazel designation for the OS.",
        ),
        "bzl_arch": attr.string(
            doc = "The Bazel designation for the architecture.",
        ),
        "spm_os": attr.string(
            doc = "The SPM designation for the OS.",
        ),
        "spm_arch": attr.string(
            doc = "The SPM designation for the architecture.",
        ),
        "spm_vendor": attr.string(
            doc = "The SPM designation for the vendor.",
        ),
    },
)

def declare_toolchains():
    for bzl_os, bzl_arch in SUPPORTED_BZL_PLATFORMS:
        impl_name = platforms.toolchain_impl_name(bzl_os, bzl_arch)
        spm_os = platforms.spm_os(bzl_os)
        spm_arch = platforms.spm_arch(bzl_arch)
        spm_vendor = platforms.spm_vendor(bzl_os)
        spm_toolchain(
            name = impl_name,
            build_tool = "//spm/internal:exec_spm_build",
            bzl_os = bzl_os,
            bzl_arch = bzl_arch,
            spm_os = spm_os,
            spm_arch = spm_arch,
            spm_vendor = spm_vendor,
        )

        toolchain_name = platforms.toolchain_name(bzl_os, bzl_arch)
        native.toolchain(
            name = toolchain_name,
            exec_compatible_with = [
                "@platforms//os:" + bzl_os,
                "@platforms//cpu:" + bzl_arch,
            ],
            target_compatible_with = [
                "@platforms//os:" + bzl_os,
                "@platforms//cpu:" + bzl_arch,
            ],
            toolchain = ":" + impl_name,
            toolchain_type = SPM_TOOLCHAIN_TYPE,
        )

def spm_register_toolchains():
    toolchain_names = platforms.toolchain_names()
    toolchain_labels = ["@cgrindel_rules_spm//spm:" + n for n in toolchain_names]
    native.register_toolchains(*toolchain_labels)

def get_spm_build_info(ctx):
    return ctx.toolchains[SPM_TOOLCHAIN_TYPE].spm_build_info
