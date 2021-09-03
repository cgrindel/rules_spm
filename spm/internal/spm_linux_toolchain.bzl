load(":providers.bzl", "SPMBuildInfo", "SPMPlatformInfo")
load(":swift_toolchains.bzl", "swift_toolchains")

# TODO: Update the non-Xcode toolchain to conform to the Bazel toolchains? Get the target OS
# and arch from the platform.

def _spm_linux_toolchain(ctx):
    target_triple = swift_toolchains.target_triple(
        arch = ctx.attr.arch,
        vendor = ctx.attr.vendor,
        sys = ctx.attr.os,
        abi = ctx.attr.abi,
    )
    spm_platform_info = SPMPlatformInfo(
        os = ctx.attr.os,
        arch = ctx.attr.arch,
        vendor = ctx.attr.vendor,
        abi = ctx.attr.abi,
    )

    spm_build_info = SPMBuildInfo(
        build_tool = ctx.executable._build_tool,
        sdk_name = None,
        target_triple = target_triple,
        spm_platform_info = spm_platform_info,
        swift_executable = ctx.attr.swift_executable,
    )

    return [spm_build_info]

spm_linux_toolchain = rule(
    implementation = _spm_linux_toolchain,
    attrs = {
        "swift_executable": attr.string(
            mandatory = True,
            doc = "Path to `swift` executable.",
        ),
        "arch": attr.string(
            doc = "The name of the architecture that this toolchain targets.",
            mandatory = True,
        ),
        "os": attr.string(
            doc = """\
            The name of the operating system that this toolchain targets.
            """,
            mandatory = True,
        ),
        "vendor": attr.string(
            doc = "The vendor for the system being targetd.",
            mandatory = True,
        ),
        "abi": attr.string(
            doc = "The abi for the system being targetd.",
        ),
        "_build_tool": attr.label(
            executable = True,
            cfg = "exec",
            # default = "//spm/internal:exec_linux_build",
            default = "//spm/internal:exec_macos_build",
        ),
    },
)
