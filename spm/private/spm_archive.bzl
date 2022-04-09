"""Definition for spm_archive rule."""

load("@bazel_build_rules_cc//cc:action_names.bzl", "CPP_LINK_STATIC_LIBRARY_ACTION_NAME")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

# Heavily inspired by
# https://github.com/bazelbuild/rules_cc/blob/main/examples/my_c_archive/my_c_archive.bzl
def _spm_archive_impl(ctx):
    cc_toolchain = find_cpp_toolchain(ctx)
    output_file = ctx.actions.declare_file("lib%s.a" % (ctx.attr.name))

    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )

    cc_common.create_linker_input(
        owner = ctx.label,
        libraries = depset(direct = [
            cc_common.create_library_to_link(
                actions = ctx.actions,
                feature_configuration = feature_configuration,
                cc_toolchain = cc_toolchain,
                static_library = output_file,
            ),
        ]),
    )

    archiver_path = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = CPP_LINK_STATIC_LIBRARY_ACTION_NAME,
    )
    archiver_variables = cc_common.create_link_variables(
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        output_file = output_file.path,
        is_using_linker = False,
    )
    command_line = cc_common.get_memory_inefficient_command_line(
        feature_configuration = feature_configuration,
        action_name = CPP_LINK_STATIC_LIBRARY_ACTION_NAME,
        variables = archiver_variables,
    )

    args = ctx.actions.args()
    args.add_all(command_line)
    args.add_all(ctx.files.o_files)

    env = cc_common.get_environment_variables(
        feature_configuration = feature_configuration,
        action_name = CPP_LINK_STATIC_LIBRARY_ACTION_NAME,
        variables = archiver_variables,
    )

    # NOTE: Purposely not setting use_default_shell_env, because we need to pass `env`.
    # See https://github.com/bazelbuild/bazel/issues/12049#issuecomment-696501036 for
    # the gory details.
    ctx.actions.run(
        executable = archiver_path,
        arguments = [args],
        env = env,
        inputs = depset(
            direct = ctx.files.o_files,
            transitive = [cc_toolchain.all_files],
        ),
        outputs = [output_file],
    )

    return [DefaultInfo(files = depset([output_file]))]

spm_archive = rule(
    implementation = _spm_archive_impl,
    attrs = {
        "o_files": attr.label(
            mandatory = True,
            allow_files = True,
            doc = """\
The object files to be combined into the clang archive using the ar tool.
""",
        ),
        "_cc_toolchain": attr.label(
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain"),
            doc = """\
The C++ toolchain from which other tools needed by the Swift toolchain (such as
`clang` and `ar`) will be retrieved.
""",
        ),
    },
    fragments = ["cpp"],
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
    incompatible_use_toolchain_transition = True,
    doc = """\
Combines object files (.o) into an archive file (.a).
""",
)
