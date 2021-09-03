load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")
load("@rules_cc//cc:action_names.bzl", "CPP_LINK_STATIC_LIBRARY_ACTION_NAME")

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

    linker_input = cc_common.create_linker_input(
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
    compilation_context = cc_common.create_compilation_context()
    linking_context = cc_common.create_linking_context(
        linker_inputs = depset(direct = [linker_input]),
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

# def _spm_archive_impl(ctx):
#     cc_toolchain = ctx.attr._cc_toolchain[cc_common.CcToolchainInfo]
#     a_filename = "lib%s.a" % (ctx.attr.name)
#     a_file = ctx.actions.declare_file(a_filename)

#     run_args = ctx.actions.args()

#     # ar commands
#     # r: replace existing or insert new files into archive
#     # c: do not warn if library had to be created
#     # s: create an archive index
#     run_args.add("rcs")
#     run_args.add(a_file)
#     run_args.add_all(ctx.files.o_files)

#     # DEBUG BEGIN
#     print("*** CHUCK cc_toolchain.ar_executable: ", cc_toolchain.ar_executable)
#     # DEBUG END

#     link_outputs = cc_common.link(
#         actions = ctx.actions,
#         # TODO: FIX ME
#         feature_configuration = None,
#         cc_toolchain = cc_toolchain,
#         # TODO: Should I create a CcCompilationOutputs with the object files?
#         compilation_outputs = None,
#         name = a_filename,
#         output_type = "dynamic_library",
#     )

#     print("*** CHUCK link_outputs.library_to_link: ", link_outputs.library_to_link)

#     ctx.actions.run(
#         inputs = ctx.files.o_files,
#         outputs = [a_file],
#         arguments = [run_args],
#         executable = cc_toolchain.ar_executable,
#         progress_message = "Creating archive file (%s)." % (a_file),
#     )
#     return [DefaultInfo(files = depset([a_file]))]

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
)
