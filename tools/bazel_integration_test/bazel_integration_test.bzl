load("@bazel_skylib//lib:paths.bzl", "paths")
load("//:bazel_versions.bzl", "SUPPORTED_BAZEL_VERSIONS")

"Define a rule for running bazel test under Bazel"

# This was lovingly inspired by
# https://github.com/bazelbuild/rules_python/blob/main/tools/bazel_integration_test/bazel_integration_test.bzl.

BAZEL_BINARY = "@build_bazel_bazel_%s//:bazel_binary" % SUPPORTED_BAZEL_VERSIONS[0].replace(".", "_")

# _ATTRS = {
#     "bazel_binary": attr.label(
#         default = BAZEL_BINARY,
#         doc = """The bazel binary files to test against.
# It is assumed by the test runner that the bazel binary is found at label_workspace/bazel (wksp/bazel.exe on Windows)""",
#     ),
#     "bazel_commands": attr.string_list(
#         default = ["info", "test --test_output=errors ..."],
#         doc = """The list of bazel commands to run.
# Note that if a command contains a bare `--` argument, the --test_arg passed to Bazel will appear before it.
# """,
#     ),
#     "workspace_files": attr.label(
#         doc = """A filegroup of all files in the workspace-under-test necessary to run the test.""",
#     ),
# }

# def _config_impl(ctx):
#     if len(SUPPORTED_BAZEL_VERSIONS) > 1:
#         fail("""
#         bazel_integration_test doesn't support multiple Bazel versions to test against yet.
#         """)
#     if len(ctx.files.workspace_files) == 0:
#         fail("""
# No files were found to run under integration testing. See comment in /.bazelrc.
# You probably need to run
#     tools/bazel_integration_test/update_deleted_packages.sh
# """)

#     # Serialize configuration file for test runner
#     config = ctx.actions.declare_file("%s.json" % ctx.attr.name)
#     ctx.actions.write(
#         output = config,
#         content = """
# {{
#     "workspaceRoot": "{TMPL_workspace_root}",
#     "bazelBinaryWorkspace": "{TMPL_bazel_binary_workspace}",
#     "bazelCommands": [ {TMPL_bazel_commands} ],
#     "distro": "rules_python/{TMPL_distro_path}"
# }}
# """.format(
#             TMPL_workspace_root = ctx.files.workspace_files[0].dirname,
#             TMPL_bazel_binary_workspace = ctx.attr.bazel_binary.label.workspace_name,
#             TMPL_bazel_commands = ", ".join(["\"%s\"" % s for s in ctx.attr.bazel_commands]),
#             TMPL_distro_path = ctx.file.distro.short_path,
#         ),
#     )

#     return [DefaultInfo(
#         files = depset([config]),
#         runfiles = ctx.runfiles(files = [config]),
#     )]

# _config = rule(
#     implementation = _config_impl,
#     doc = "Configures an integration test that runs a specified version of bazel against an external workspace.",
#     attrs = _ATTRS,
# )

def glob_workspace_files(workspace_path):
    return native.glob(
        [paths.join(workspace_path, "**", "*")],
        exclude = [paths.join(workspace_path, "bazel-*", "**")],
    )

def bazel_integration_test(name, workspace_files = None, **kwargs):
    """Wrapper macro to set default srcs and run a py_test with config
    Args:
        name: name of the resulting py_test
        workspace_files: Optional. A `list` of files for the child workspace.
        **kwargs: additional attributes like timeout and visibility
    """

    if workspace_files == None:
        workspace_files = "_%s_sources" % name
        if name.endswith("_example"):
            workspace_path = name[:-len("_example")]
        else:
            workspace_path = name
        native.filegroup(
            name = workspace_files,
            srcs = glob_workspace_files(workspace_path),
        )

    native.sh_test(
        name = name,
        srcs = ["//tools/bazel_integration_test:integration_test_runner.sh"],
        data = [
            BAZEL_BINARY,
            workspace_files,
        ],
        **kwargs
    )
