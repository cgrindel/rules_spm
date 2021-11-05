load("@bazel_skylib//lib:paths.bzl", "paths")
load("//:bazel_versions.bzl", "SUPPORTED_BAZEL_VERSIONS")
load("@bazel_skylib//rules:select_file.bzl", "select_file")
load("@cgrindel_bazel_starlib//rules:filter_srcs.bzl", "filter_srcs")

"Define a rule for running bazel test under Bazel"

# This was lovingly inspired by
# https://github.com/bazelbuild/rules_python/blob/main/tools/bazel_integration_test/bazel_integration_test.bzl.

BAZEL_BINARY = "@build_bazel_bazel_%s//:bazel_binary" % SUPPORTED_BAZEL_VERSIONS[0].replace(".", "_")

def glob_workspace_files(workspace_path):
    return native.glob(
        [paths.join(workspace_path, "**", "*")],
        exclude = [paths.join(workspace_path, "bazel-*", "**")],
    )

DEFAULT_BAZEL_CMDS = ["info", "test //..."]

def bazel_integration_test(
        name,
        workspace_files = None,
        bazel_cmds = DEFAULT_BAZEL_CMDS,
        **kwargs):
    """Wrapper macro to set default srcs and run a py_test with config
    Args:
        name: name of the resulting py_test
        workspace_files: Optional. A `list` of files for the child workspace.
        bazel_cmds: A `list` of `string` values that represent arguments for
                    Bazel.
        **kwargs: additional attributes like timeout and visibility
    """

    # if workspace_files == None:
    #     workspace_files = name + "_sources"
    #     if name.endswith("_example"):
    #         workspace_path = name[:-len("_example")]
    #     else:
    #         workspace_path = name
    #     native.filegroup(
    #         name = workspace_files,
    #         srcs = glob_workspace_files(workspace_path),
    #     )
    if workspace_files == None:
        if name.endswith("_example"):
            workspace_path = name[:-len("_example")]
        else:
            workspace_path = name
        workspace_files = glob_workspace_files(workspace_path)

    workspace_files_name = name + "_sources"
    native.filegroup(
        name = workspace_files_name,
        srcs = workspace_files,
    )

    bazel_bin_name = name + "_bazel_binary"
    select_file(
        name = bazel_bin_name,
        srcs = BAZEL_BINARY,
        subpath = "bazel",
    )

    bazel_wksp_file_name = name + "_bazel_workspace_file"
    filter_srcs(
        name = bazel_wksp_file_name,
        # srcs = workspace_files,
        srcs = [workspace_files_name],
        filename_ends_with = "WORKSPACE",
        expected_count = 1,
    )

    bazel_cmd_args = []
    for cmd in bazel_cmds:
        bazel_cmd_args.extend(["--bazel_cmd", "\"" + cmd + "\""])

    if not name.endswith("_test"):
        test_name = name + "_test"
    else:
        test_name = name

    native.sh_test(
        name = test_name,
        srcs = ["//tools/bazel_integration_test:integration_test_runner.sh"],
        args = [
            "--bazel",
            "$(location :%s)" % (bazel_bin_name),
            "--workspace",
            "$(location :%s)" % (bazel_wksp_file_name),
        ] + bazel_cmd_args,
        data = [
            BAZEL_BINARY,
            bazel_bin_name,
            workspace_files_name,
            # workspace_files,
            bazel_wksp_file_name,
        ],
        **kwargs
    )
