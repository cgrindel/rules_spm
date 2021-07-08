load("@bazel_skylib//lib:paths.bzl", "paths")
load("//spm/internal:providers.bzl", "SPMPackageInfo", "create_clang_module", "create_swift_module")
load(
    "//spm/internal:package_description.bzl",
    "exported_library_targets",
    "parse_package_description_json",
)

# GH004: Update this to use a toolchain to execute "swift build".
# https://docs.bazel.build/versions/main/toolchains.html

def is_module_file(target_name, file):
    if file.is_directory:
        return False
    dir_parts = file.short_path.split("/")
    for dir_part in dir_parts:
        if dir_part == target_name:
            return True
    return False

def is_hdr_file(file):
    if file.is_directory or file.extension != "h":
        return False
    dir_name = paths.basename(file.dirname)
    return dir_name == "include"

def _declare_clang_target_files(ctx, target, build_config_dirname):
    all_files = []

    target_name = target["name"]
    module_name = target["c99name"]

    hdrs = [src for src in ctx.files.srcs if is_module_file(target_name, src) and is_hdr_file(src)]

    target_build_dirname = "%s/%s.build" % (build_config_dirname, target_name)
    o_files = []
    for src in target["sources"]:
        o_files.append(ctx.actions.declare_file("%s/%s.o" % (target_build_dirname, src)))
    all_files.extend(o_files)

    return create_clang_module(
        module_name = module_name,
        o_files = o_files,
        hdrs = hdrs,
        all_files = all_files,
    )

def _declare_swift_target_files(ctx, target, build_config_dirname):
    all_files = []
    o_files = []

    target_name = target["name"]
    module_name = target["c99name"]

    swiftdoc = ctx.actions.declare_file("%s/%s.swiftdoc" % (build_config_dirname, target_name))
    swiftmodule = ctx.actions.declare_file("%s/%s.swiftmodule" % (build_config_dirname, target_name))
    swiftsourceinfo = ctx.actions.declare_file("%s/%s.swiftsourceinfo" % (build_config_dirname, target_name))
    all_files.extend([swiftdoc, swiftmodule, swiftsourceinfo])

    target_build_dirname = "%s/%s.build" % (build_config_dirname, target_name)
    all_files.extend([
        ctx.actions.declare_file("%s/%s-Swift.h" % (target_build_dirname, target_name)),
        # For Swift modules, there is one .d file per module. For C modules, there appears to be
        # one per .c file.
        ctx.actions.declare_file("%s/%s.d" % (target_build_dirname, target_name)),
        ctx.actions.declare_file("%s/master.swiftdeps" % (target_build_dirname)),
        ctx.actions.declare_file("%s/module.modulemap" % (target_build_dirname)),
        ctx.actions.declare_file("%s/output-file-map.json" % (target_build_dirname)),
    ])

    for src in target["sources"]:
        o_files.append(ctx.actions.declare_file("%s/%s.o" % (target_build_dirname, src)))
    all_files.extend(o_files)

    return create_swift_module(
        module_name = module_name,
        o_files = o_files,
        swiftdoc = swiftdoc,
        swiftmodule = swiftmodule,
        swiftsourceinfo = swiftsourceinfo,
        all_files = all_files,
    )

def _spm_package_impl(ctx):
    build_output_dirname = "spm_build_output"
    build_output_dir = ctx.actions.declare_directory(build_output_dirname)
    all_files = []

    # Parse the package description JSON.
    pkg_desc = parse_package_description_json(ctx.attr.package_description_json)

    # GH005: Figure out how to determine the arch part of the directory (e.g. x86_64-apple-macosx).
    build_config_dirname = "%s/x86_64-apple-macosx/%s" % (build_output_dirname, ctx.attr.configuration)
    all_files.append(ctx.actions.declare_file("%s/description.json" % (build_config_dirname)))

    targets = exported_library_targets(pkg_desc)

    swift_module_infos = []
    clang_module_infos = []
    for target in targets:
        module_type = target["module_type"]
        if module_type == "SwiftTarget":
            swift_module_info = _declare_swift_target_files(ctx, target, build_config_dirname)
            swift_module_infos.append(swift_module_info)
            all_files.extend(swift_module_info.all_files)
        if module_type == "ClangTarget":
            clang_module_info = _declare_clang_target_files(ctx, target, build_config_dirname)
            clang_module_infos.append(clang_module_info)
            all_files.extend(clang_module_info.all_files)

    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        outputs = [build_output_dir] + all_files,
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

    return [
        DefaultInfo(files = depset(all_files)),
        SPMPackageInfo(
            name = pkg_desc["name"],
            swift_modules = swift_module_infos,
            clang_modules = clang_module_infos,
        ),
    ]

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
