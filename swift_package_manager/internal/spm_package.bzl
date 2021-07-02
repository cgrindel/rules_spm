# load("@erickj_bazel_json//lib:json_parser.bzl", "json_parse")

# TODO: Update this to use a toolchain to execute "swift build".
# https://docs.bazel.build/versions/main/toolchains.html

def _spm_package_impl(ctx):
    build_output_dir = ctx.actions.declare_directory("spm_build_output")
    outputs = []
    # for in_file in ctx.files.srcs:
    #     if in_file.extension == "swift":
    #         o_path = "%s.o" % (in_file.short_path)
    #         outputs.append(ctx.actions.declare_file(o_path))

    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        outputs = [build_output_dir] + outputs,
        arguments = [ctx.attr.configuration, ctx.attr.package_path, build_output_dir.path],
        command = """
        swift build \
          --manifest-cache none \
          --disable-sandbox \
          --configuration $1 \
          --package-path $2 \
          --build-path "$3"
        """,
        progress_message = "Building Swift package (%s) using SPM." % (ctx.attr.package_path),
    )

    return [DefaultInfo(files = depset([build_output_dir]))]

_attrs = {
    "srcs": attr.label_list(
        allow_files = True,
        mandatory = True,
    ),
    # "package_description": attr.label(
    #     allow_single_file = True,
    #     doc = "Points to the JSON file that was generated from the spm_repository repository rule.",
    # ),
    "configuration": attr.string(
        default = "release",
        values = ["release", "debug"],
        doc = "The configuration to use when executing swift build (e.g. debug, release).",
    ),
    "package_path": attr.string(
        doc = "Directory which contains the Package.swift (i.e. swift build --package-path VALUE).",
    ),
}

spm_package = rule(
    implementation = _spm_package_impl,
    attrs = _attrs,
    doc = "Builds the specified Swift package.",
)
