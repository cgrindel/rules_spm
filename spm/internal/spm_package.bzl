load("@bazel_skylib//lib:paths.bzl", "paths")
load(
    "//spm/internal:providers.bzl",
    "SPMPackageInfo",
    "create_clang_module",
    "create_copy_info",
    "create_swift_module",
)
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

def _create_clang_module_build_info(module_name, modulemap, o_files, src_hdrs, build_dir, all_build_outs):
    return struct(
        module_name = module_name,
        modulemap = modulemap,
        o_files = o_files,
        src_hdrs = src_hdrs,
        build_dir = build_dir,
        all_build_outs = all_build_outs,
    )

def _declare_clang_target_files(ctx, target, build_config_dirname):
    all_build_outs = []

    target_name = target["name"]
    module_name = target["c99name"]

    target_build_dirname = "%s/%s.build" % (build_config_dirname, target_name)

    modulemap = ctx.actions.declare_file("%s/module.modulemap" % (target_build_dirname))
    all_build_outs.append(modulemap)

    src_hdrs = [src for src in ctx.files.srcs if is_module_file(target_name, src) and is_hdr_file(src)]

    o_files = []
    for src in target["sources"]:
        o_files.append(ctx.actions.declare_file("%s/%s.o" % (target_build_dirname, src)))
    all_build_outs.extend(o_files)

    return _create_clang_module_build_info(
        module_name = module_name,
        modulemap = modulemap,
        o_files = o_files,
        src_hdrs = src_hdrs,
        build_dir = target_build_dirname,
        all_build_outs = all_build_outs,
    )

def _copy_hdr_files(ctx, clang_module_build_info):
    copy_infos = []
    for src_hdr in clang_module_build_info.src_hdrs:
        out_hdr = ctx.actions.declare_file(
            "%s/include/%s" % (clang_module_build_info.build_dir, src_hdr.basename),
        )
        ctx.actions.run_shell(
            inputs = [src_hdr],
            outputs = [out_hdr],
            arguments = [src_hdr.path, out_hdr.path],
            command = """
            cp "$1" "$2"
            """,
            progress_message = "Copying header file to output.",
        )
        copy_infos.append(create_copy_info(src = src_hdr, dest = out_hdr))
    return copy_infos

def _create_clang_module(clang_module_build_info, hdrs):
    return create_clang_module(
        module_name = clang_module_build_info.module_name,
        o_files = clang_module_build_info.o_files,
        hdrs = hdrs,
        all_outputs = clang_module_build_info.all_build_outs + hdrs,
    )

def _declare_swift_target_files(ctx, target, build_config_dirname):
    all_build_outs = []
    o_files = []

    target_name = target["name"]
    module_name = target["c99name"]

    swiftdoc = ctx.actions.declare_file("%s/%s.swiftdoc" % (build_config_dirname, target_name))
    swiftmodule = ctx.actions.declare_file("%s/%s.swiftmodule" % (build_config_dirname, target_name))
    swiftsourceinfo = ctx.actions.declare_file("%s/%s.swiftsourceinfo" % (build_config_dirname, target_name))
    all_build_outs.extend([swiftdoc, swiftmodule, swiftsourceinfo])

    target_build_dirname = "%s/%s.build" % (build_config_dirname, target_name)
    # all_build_outs.extend([
    #     ctx.actions.declare_file("%s/%s-Swift.h" % (target_build_dirname, target_name)),
    #     # For Swift modules, there is one .d file per module. For C modules, there appears to be
    #     # one per .c file.
    #     ctx.actions.declare_file("%s/%s.d" % (target_build_dirname, target_name)),
    #     ctx.actions.declare_file("%s/master.swiftdeps" % (target_build_dirname)),
    #     ctx.actions.declare_file("%s/module.modulemap" % (target_build_dirname)),
    #     ctx.actions.declare_file("%s/output-file-map.json" % (target_build_dirname)),
    # ])

    for src in target["sources"]:
        o_files.append(ctx.actions.declare_file("%s/%s.o" % (target_build_dirname, src)))
    all_build_outs.extend(o_files)

    return create_swift_module(
        module_name = module_name,
        o_files = o_files,
        swiftdoc = swiftdoc,
        swiftmodule = swiftmodule,
        swiftsourceinfo = swiftsourceinfo,
        all_outputs = all_build_outs,
    )

def _spm_package_impl(ctx):
    # build_output_dirname = "spm_build_output"

    foo_file = ctx.actions.declare_file("_foo")
    ctx.actions.write(foo_file, "")

    # build_output_dir = ctx.actions.declare_directory(build_output_dirname)
    all_build_outs = []

    # Parse the package description JSON.
    pkg_desc = parse_package_description_json(ctx.attr.package_description_json)

    # GH005: Figure out how to determine the arch part of the directory (e.g. x86_64-apple-macosx).
    # build_config_dirname = "%s/x86_64-apple-macosx/%s" % (build_output_dirname, ctx.attr.configuration)
    # all_build_outs.append(ctx.actions.declare_file("%s/description.json" % (build_config_dirname)))
    build_config_dirname = "x86_64-apple-macosx/%s" % (ctx.attr.configuration)

    # targets = exported_library_targets(pkg_desc)
    # targets = pkg_desc["targets"]
    targets = [t for t in pkg_desc["targets"] if t["type"] == "library"]

    swift_module_infos = []
    clang_module_build_infos = []
    for target in targets:
        module_type = target["module_type"]
        if module_type == "SwiftTarget":
            swift_module_info = _declare_swift_target_files(ctx, target, build_config_dirname)
            swift_module_infos.append(swift_module_info)
            all_build_outs.extend(swift_module_info.all_outputs)
        if module_type == "ClangTarget":
            clang_module_build_info = _declare_clang_target_files(ctx, target, build_config_dirname)
            clang_module_build_infos.append(clang_module_build_info)
            all_build_outs.extend(clang_module_build_info.all_build_outs)

    build_path = foo_file.dirname
    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        # outputs = [build_output_dir] + all_build_outs,
        outputs = all_build_outs,
        # arguments = [ctx.attr.configuration, ctx.attr.package_path, build_output_dir.path],
        # arguments = [ctx.attr.configuration, ctx.attr.package_path, build_output_dirname],
        arguments = [ctx.attr.configuration, ctx.attr.package_path, build_path],
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

    # Copy the header files to the output.
    hdr_copy_infos = []
    clang_module_infos = []
    for clang_module_build_info in clang_module_build_infos:
        copy_infos = _copy_hdr_files(ctx, clang_module_build_info)
        hdr_copy_infos.extend(copy_infos)
        out_hdrs = [ci.dest for ci in copy_infos]
        clang_module_infos.append(_create_clang_module(clang_module_build_info, out_hdrs))

    # TODO: Update the module.modulemap files generated by the Clang targets to
    # point to the include files that have been output.

    return [
        DefaultInfo(files = depset(all_build_outs + [ci.dest for ci in hdr_copy_infos])),
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
