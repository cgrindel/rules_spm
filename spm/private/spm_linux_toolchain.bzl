"""Definition for spm_linux_toolchain rule."""

load(":actions.bzl", "action_names", "actions")
load(":providers.bzl", "SPMPlatformInfo", "SPMToolchainInfo")
load(":swift_toolchains.bzl", "swift_toolchains")

# GH050: Update the non-Xcode toolchain to conform to the Bazel toolchains? Get the target OS
# and arch from the platform.

def _is_spm_at_least_version(ctx, desired_version):
    current_version = apple_common.dotted_version(ctx.attr.spm_version)
    if not current_version:
        fail(
            """\
Could not parse the version number for Swift package manager. {version}\
""".format(
                version = ctx.attr.spm_version,
            ),
        )
    desired_version_value = apple_common.dotted_version(desired_version)
    return current_version >= desired_version_value

def _create_build_tool_config(ctx, target_triple, spm_configuration):
    swift_worker = ctx.executable._swift_worker
    swift_exec = ctx.attr.swift_exec
    args = [
        "--worker",
        swift_worker,
        "--swift",
        swift_exec,
    ]

    for spm_utility in ctx.files._spm_utilities:
        args.extend(["--spm_utility", spm_utility])

    args.extend(["-Xspm", "--disable-sandbox"])
    args.extend(["-Xspm", "--configuration", "-Xspm", spm_configuration])

    if _is_spm_at_least_version(ctx, "5.4"):
        args.extend(["-Xspm", "--manifest-cache", "-Xspm", "none"])
        args.extend(["-Xspm", "--disable-repository-cache"])

    args.extend(["-Xswiftc", "-target", "-Xswiftc", target_triple])
    args.extend(["-Xcc", "-target", "-Xcc", target_triple])

    env = {}
    execution_requirements = {}

    return actions.tool_config(
        executable = ctx.executable._build_tool,
        additional_tools = [swift_worker] + ctx.files._spm_utilities,
        args = args,
        env = env,
        execution_requirements = execution_requirements,
    )

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

    # GH073: Can be `release` or `debug`. Provide a means for configuring this value.
    spm_configuration = "release"

    tool_configs = {
        action_names.BUILD: _create_build_tool_config(
            ctx = ctx,
            target_triple = target_triple,
            spm_configuration = spm_configuration,
        ),
    }

    spm_toolchain_info = SPMToolchainInfo(
        spm_configuration = spm_configuration,
        target_triple = target_triple,
        spm_platform_info = spm_platform_info,
        tool_configs = tool_configs,
    )

    return [spm_toolchain_info]

spm_linux_toolchain = rule(
    implementation = _spm_linux_toolchain,
    attrs = {
        "abi": attr.string(
            doc = "The abi for the system being targetd.",
        ),
        "arch": attr.string(
            doc = "The name of the architecture that this toolchain targets.",
            mandatory = True,
        ),
        "os": attr.string(
            doc = """\
The name of the operating system that this toolchain targets.\
""",
            mandatory = True,
        ),
        "spm_version": attr.string(
            mandatory = True,
            doc = """\
The version number for Swift package manager. It is the value returned from \
`swift package --version`.\
""",
        ),
        "swift_exec": attr.string(
            mandatory = True,
            doc = """\
The path to the Swift executable.\
""",
        ),
        "vendor": attr.string(
            doc = "The vendor for the system being targetd.",
            mandatory = True,
        ),
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
An executable that wraps Swift compiler invocations and also provides support \
for incremental compilation using a persistent mode.\
""",
            executable = True,
        ),
    },
    doc = "Provides toolchain information for SPM builds on Linux.",
)
