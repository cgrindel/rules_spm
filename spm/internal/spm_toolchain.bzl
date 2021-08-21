load(":platforms.bzl", "SPMOS_SPMARCH", "platforms")

SpmBuildInfo = provider(
    doc = "Information about how to invoke the Swift package manager.",
    fields = ["build_tool", "os", "arch"],
)

def _spm_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        spmbuildinfo = SpmBuildInfo(
            build_tool = ctx.executable.build_tool,
            os = ctx.attr.os,
            arch = ctx.attr.arch,
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

def declare_toolchains():
    for spmos, spmarch in SPMOS_SPMARCH:
        impl_name = platforms.toolchain_impl_name(spmos, spmarch)
        spm_toolchain(
            name = impl_name,
            build_tool = "//spm/internal:exec_spm_build",
            os = spmos,
            arch = spmarch,
        )

        toolchain_name = platforms.toolchain_name(spmos, spmarch)
        native.toolchain(
            name = toolchain_name,
            exec_compatible_with = [
                "@platforms//os:" + spmos,
                "@platforms//cpu:" + spmarch,
            ],
            target_compatible_with = [
                "@platforms//os:" + spmos,
                "@platforms//cpu:" + spmarch,
            ],
            toolchain = ":" + impl_name,
            toolchain_type = "@cgrindel_rules_spm//spm:toolchain_type",
        )

def spm_register_toolchains():
    toolchain_names = platforms.toolchain_names()
    toolchain_labels = ["@cgrindel_rules_spm//spm:" + n for n in toolchain_names]
    native.register_toolchains(*toolchain_labels)
