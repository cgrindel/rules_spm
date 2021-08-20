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
        "os": attr.string(
            doc = "The OS to build.",
        ),
        "arch": attr.string(
            doc = "The architecture to build.",
        ),
    },
)

SPMOS_SPMARCH = [
    ("macos", "x86_64"),
    ("macos", "arm64"),
    ("linux", "x86_64"),
    ("linux", "arm64"),
]

def declare_toolchains():
    for spmos, spmarch in SPMOS_SPMARCH:
        impl_name = "spm_%s_%s" % (spmos, spmarch)
        spm_toolchain(
            name = impl_name,
            build_tool = "//spm/internal:exec_spm_build",
            os = spmos,
            arch = spmarch,
        )

        native.toolchain(
            name = "%s_toolchain" % (impl_name),
            exec_compatible_with = [
                "@platforms//os:%s" % (spmos),
                "@platforms//cpu:%s" % (spmarch),
            ],
            target_compatible_with = [
                "@platforms//os:%s" % (spmos),
                "@platforms//cpu:%s" % (spmarch),
            ],
            toolchain = ":" + impl_name,
            toolchain_type = "@cgrindel_rules_spm//spm:toolchain_type",
        )
