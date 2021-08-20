SpmBuildInfo = provider(
    doc = "Information about how to invoke the Swift package manager.",
    fields = ["build_tool"],
)

def _spm_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        spmbuildinfo = SpmBuildInfo(
            build_tool = ctx.executable.build_tool,
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
    },
)
