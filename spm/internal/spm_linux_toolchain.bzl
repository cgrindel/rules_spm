load(":providers.bzl", "SPMBuildInfo", "SPMPlatformInfo")
load(":swift_toolchains.bzl", "swift_toolchains")

# TODO: Update the non-Xcode toolchain to conform to the Bazel toolchains? Get the target OS
# and arch from the platform.

def _spm_linux_toolchain(ctx):
    # TODO: What should we do with the SDK?
    sdk_name = "no-sdk"

    target_triple = swift_toolchains.target_triple(
        arch = ctx.attr.arch,
        vendor = ctx.attr.vendor,
        sys = ctx.attr.os,
    )
    spm_platform_info = SPMPlatformInfo(
        os = ctx.attr.os,
        arch = ctx.attr.arch,
        vendor = ctx.attr.vendor,
    )

    spm_build_info = SPMBuildInfo(
        build_tool = ctx.executable._build_tool,
        sdk_name = sdk_name,
        target_triple = target_triple,
        spm_platform_info = spm_platform_info,
    )

    return [spm_build_info]

spm_linux_toolchain = rule(
    implementation = _spm_linux_toolchain,
    attrs = {
        # TODO: Do I need the swift executable?
        "swift": attr.string(
            mandatory = True,
            doc = "Path to `swift` executable."
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
        "_build_tool": attr.label(
            executable = True,
            cfg = "exec",
            default = "//spm/internal:exec_linux_build",
        ),
    },
)
