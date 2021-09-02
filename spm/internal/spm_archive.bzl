load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

def _spm_archive_impl(ctx):
    cc_toolchain = ctx.attr._cc_toolchain[cc_common.CcToolchainInfo]
    a_file = ctx.actions.declare_file("lib%s.a" % (ctx.attr.name))

    run_args = ctx.actions.args()
    # ar commands
    # r: replace existing or insert new files into archive
    # c: do not warn if library had to be created
    # s: create an archive index
    run_args.add("rcs")
    run_args.add(a_file)
    run_args.add_all(ctx.files.o_files)

    ctx.actions.run(
        inputs = ctx.files.o_files,
        outputs = [a_file],
        arguments = [run_args],
        executable = cc_toolchain.ar_executable,
        progress_message = "Creating archive file (%s)." % (a_file)
    )
    return [DefaultInfo(files = depset([a_file]))]

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
        )
    },
)
