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

def is_target_file(target_name, file):
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

def is_modulemap_file(file):
    if file.is_directory:
        return False
    return file.basename == "module.modulemap"

def _create_clang_module_build_info(module_name, modulemap, o_files, hdrs, files_to_copy, build_dir, all_build_outs):
    return struct(
        module_name = module_name,
        modulemap = modulemap,
        o_files = o_files,
        hdrs = hdrs,
        build_dir = build_dir,
        files_to_copy = files_to_copy,
        all_build_outs = all_build_outs,
    )

def _modulemap_for_target(ctx, target_name):
    for src in ctx.files.srcs:
        if is_target_file(target_name, src) and is_modulemap_file(src):
            return src
    return None

def _declare_clang_target_files(ctx, target, build_config_dirname):
    all_build_outs = []
    files_to_copy = []

    target_name = target["name"]
    module_name = target["c99name"]

    target_build_dirname = "%s/%s.build" % (build_config_dirname, target_name)

    create_include_dir = False
    include_dirname = "%s/include" % (target_build_dirname)

    src_modulemap = _modulemap_for_target(ctx, target_name)
    if src_modulemap:
        create_include_dir = True
        out_modulemap = ctx.actions.declare_file(
            "%s/%s" % (include_dirname, src_modulemap.basename),
        )
        files_to_copy.append(create_copy_info(src_modulemap, out_modulemap))
    else:
        out_modulemap = ctx.actions.declare_file("%s/module.modulemap" % (target_build_dirname))
        all_build_outs.append(out_modulemap)

    src_hdrs = [src for src in ctx.files.srcs if is_target_file(target_name, src) and is_hdr_file(src)]
    out_hdrs = []
    for src_hdr in src_hdrs:
        create_include_dir = True
        out_hdr = ctx.actions.declare_file("%s/%s" % (include_dirname, src_hdr.basename))
        out_hdrs.append(out_hdr)
        files_to_copy.append(create_copy_info(src_hdr, out_hdr))

    o_files = []
    for src in target["sources"]:
        o_files.append(ctx.actions.declare_file("%s/%s.o" % (target_build_dirname, src)))
    all_build_outs.extend(o_files)

    # if create_include_dir:
    #     include_dir = ctx.actions.declare_directory(include_dirname)
    #     ctx.actions.run_shell(
    #         outputs = [include_dir],
    #         arguments = [include_dir.path],
    #         command = """
    #         mkdir -p "$1"
    #         """,
    #         mnemonic = "Mkdir",
    #         progress_message = "Make include directory (%s)" % (include_dir.path),
    #     )

    return _create_clang_module_build_info(
        module_name = module_name,
        modulemap = out_modulemap,
        o_files = o_files,
        hdrs = out_hdrs,
        files_to_copy = files_to_copy,
        build_dir = target_build_dirname,
        all_build_outs = all_build_outs,
    )

def _copy_files(ctx, copy_info):
    # ctx.actions.run_shell(
    #     inputs = [copy_info.src],
    #     outputs = [copy_info.dest],
    #     arguments = [copy_info.src.path, copy_info.dest.path],
    #     command = """
    #     cp "$1" "$2"
    #     """,
    #     progress_message = "Copying file to output (%s)." % (copy_info.dest.path),
    # )
    # ctx.actions.symlink(
    #     output = copy_info.dest,
    #     target_file = copy_info.src,
    #     progress_message = "Creating symlink (%s)." % (copy_info.dest.path),
    # )
    ctx.actions.run_shell(
        inputs = [copy_info.src],
        outputs = [copy_info.dest],
        arguments = [copy_info.src.path, copy_info.dest.path],
        command = """
        mkdir -p $(dirname "$2")
        cp "$1" "$2"
        """,
        progress_message = "Copying file to output (%s)." % (copy_info.dest.path),
    )

def _create_clang_module(clang_module_build_info):
    copied_files = [copy_info.dest for copy_info in clang_module_build_info.files_to_copy]
    return create_clang_module(
        module_name = clang_module_build_info.module_name,
        o_files = clang_module_build_info.o_files,
        hdrs = clang_module_build_info.hdrs,
        modulemap = clang_module_build_info.modulemap,
        all_outputs = clang_module_build_info.all_build_outs + copied_files,
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

    # DEBUG BEGIN
    bar_file = ctx.actions.declare_file("%s/CNIOWindows.build/include/bar" % (build_config_dirname))
    # DEBUG END

    build_path = foo_file.dirname
    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        outputs = all_build_outs + [bar_file],
        arguments = [ctx.attr.configuration, ctx.attr.package_path, build_path, bar_file.path],
        command = """
        swift build \
          --manifest-cache none \
          --disable-sandbox \
          --configuration $1 \
          --package-path $2 \
          --build-path "$3"

        mkdir -p $(dirname "$4")
        touch "$4"
        """,
        progress_message = "Building Swift package (%s) using SPM." % (ctx.attr.package_path),
    )
    # ctx.actions.run_shell(
    #     inputs = ctx.files.srcs,
    #     outputs = all_build_outs,
    #     arguments = [ctx.attr.configuration, ctx.attr.package_path, build_path],
    #     command = """
    #     swift build \
    #       --manifest-cache none \
    #       --disable-sandbox \
    #       --configuration $1 \
    #       --package-path $2 \
    #       --build-path "$3"
    #     """,
    #     progress_message = "Building Swift package (%s) using SPM." % (ctx.attr.package_path),
    # )
    # ctx.actions.run_shell(
    #     outputs = [bar_file],
    #     arguments = [bar_file.path],
    #     command = """
    #     mkdir -p $(dirname "$1")
    #     touch "$1"
    #     """,
    #     progress_message = "Create bar file",
    # )

    for clang_module_build_info in clang_module_build_infos:
        for copy_info in clang_module_build_info.files_to_copy:
            _copy_files(ctx, copy_info)

    clang_module_infos = [_create_clang_module(cmbi) for cmbi in clang_module_build_infos]

    all_outputs = []
    for smi in swift_module_infos:
        all_outputs.extend(smi.all_outputs)
    for cmi in clang_module_infos:
        all_outputs.extend(cmi.all_outputs)

    # TODO: Update the module.modulemap files generated by the Clang targets to
    # point to the include files that have been output.

    # DEBUG BEGIN
    print("*** CHUCK all_outputs: ", len(all_outputs))
    for out in all_outputs:
        print("*** CHUCK out: ", out)

    # DEBUG END

    return [
        DefaultInfo(files = depset(all_outputs)),
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
