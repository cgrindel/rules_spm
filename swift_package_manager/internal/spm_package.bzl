load("@erickj_bazel_json//lib:json_parser.bzl", "json_parse")

# TODO: Update this to use a toolchain to execute "swift build".
# https://docs.bazel.build/versions/main/toolchains.html

def _spm_package_impl(ctx):
    build_output_dirname = "spm_build_output"
    build_output_dir = ctx.actions.declare_directory(build_output_dirname)
    outputs = []
    # for in_file in ctx.files.srcs:
    #     if in_file.extension == "swift":
    #         o_path = "%s.o" % (in_file.short_path)
    #         outputs.append(ctx.actions.declare_file(o_path))

    # Parse the package description JSON.
    pkg_desc = json_parse(ctx.attr.package_description_json)

    targets_dict = dict([(p["name"], p) for p in pkg_desc["targets"]])

    build_config_dirname = "%s/x86_64-apple-macosx/%s" % (build_output_dirname, ctx.attr.configuration)
    target_names = []
    for product in pkg_desc["products"]:
        for target_name in product["targets"]:
            if target_name not in target_names:
                target_names.append(target_name)

    targets = [targets_dict[target_name] for target_name in target_names]
    for target in targets:
        target_name = target["name"]
        outputs.extend([
            ctx.actions.declare_file("%s/%s.swiftdoc" % (build_config_dirname, target_name)),
            ctx.actions.declare_file("%s/%s.swiftmodule" % (build_config_dirname, target_name)),
            ctx.actions.declare_file("%s/%s.swiftsourceinfo" % (build_config_dirname, target_name)),
        ])
        # target_build_dir = "%s/%s" % (build_config_dirname, target_name)

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
    "configuration": attr.string(
        default = "release",
        values = ["release", "debug"],
        doc = "The configuration to use when executing swift build (e.g. debug, release).",
    ),
    "package_description_json": attr.string(
        mandatory = True,
        doc = "JSON string which describes the package (i.e. swift package describe --type json).",
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
