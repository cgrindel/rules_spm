load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_skylib//lib:sets.bzl", "sets")
load("@bazel_skylib//lib:paths.bzl", "paths")
load("@build_bazel_rules_swift//swift:swift.bzl", "SwiftToolchainInfo", "swift_common")
load(
    "//spm/internal:providers.bzl",
    "SPMPackageInfo",
    "create_clang_module",
    "create_copy_info",
    "create_swift_module",
)
load("//spm/internal:package_description.bzl", pds = "package_descriptions")
load("//spm/internal:files.bzl", "contains_path", "is_hdr_file", "is_modulemap_file", "is_target_file")

def _create_clang_module_build_info(module_name, modulemap, o_files, hdrs, build_dir, all_build_outs, other_outs, copy_infos):
    return struct(
        module_name = module_name,
        modulemap = modulemap,
        o_files = o_files,
        hdrs = hdrs,
        build_dir = build_dir,
        all_build_outs = all_build_outs,
        other_outs = other_outs,
        copy_infos = copy_infos,
    )

def _find_public_hdrs(ctx, target_name):
    # Look for header files under the include directory.
    include_path = "Sources/%s/include" % (target_name)
    return [s for s in ctx.files.srcs if is_hdr_file(s) and contains_path(s, include_path)]

def _ends_with_any(file, targets):
    path = file.path
    for t in targets:
        if path.endswith(t):
            return True
    return False

def _declare_clang_target_files(ctx, target, build_config_dirname, modulemap_dir_path):
    all_build_outs = []
    other_outs = []
    copy_infos = []

    target_name = target["name"]
    module_name = target["c99name"]

    target_build_dirname = "%s/%s.build" % (build_config_dirname, target_name)
    target_modulemap_dirname = "%s/%s.build" % (modulemap_dir_path, target_name)

    # Check if public header paths were provided. If so, then we need to find the corresponding
    # src files.
    public_hdr_paths = ctx.attr.clang_module_headers.get(target_name, default = [])

    public_hdrs = []
    if len(public_hdr_paths) > 0:
        public_hdrs = [f for f in ctx.files.srcs if _ends_with_any(f, public_hdr_paths)]

    # If no public hdr files were specified/found, then try to find them.
    if len(public_hdrs) == 0:
        public_hdrs = _find_public_hdrs(ctx, target_name)

    # If we still have no public hdr files, then fail.
    if len(public_hdrs) == 0:
        fail("No public header files were found for %s target." % (target_name))

    # Copy all of the public headers to the output during the SPM build
    for hdr in public_hdrs:
        out_hdr = ctx.actions.declare_file("%s/%s" % (target_build_dirname, hdr.basename))
        copy_infos.append(create_copy_info(hdr, out_hdr))
        all_build_outs.append(out_hdr)

    # The gen_modulemap is where the generated modulemap will initially be written.
    # The out_modulemap is where the generated modulemap will be copied after the SPM build.
    out_modulemap = ctx.actions.declare_file("%s/module.modulemap" % (target_build_dirname))
    all_build_outs.append(out_modulemap)
    gen_modulemap = ctx.actions.declare_file("%s/module.modulemap" % (target_modulemap_dirname))

    # The module.modulemap template uses an umbrella header declaration. This means that every header
    # file in the directory or subdirectory of the specified header will be used as a public. Since
    # we will be copying all of the header files for the target to the same directory, we can get
    # away with specifying a single umbrella header.
    umbrella_hdr = public_hdrs[0]
    substitutions = {
        "{spm_module_name}": module_name,
        "{spm_module_header}": umbrella_hdr.basename,
    }
    ctx.actions.expand_template(
        template = ctx.file._modulemap_tpl,
        output = gen_modulemap,
        substitutions = substitutions,
    )
    copy_infos.append(create_copy_info(gen_modulemap, out_modulemap))

    # Declare the Mach-O files.
    o_files = []
    for src in target["sources"]:
        o_files.append(ctx.actions.declare_file("%s/%s.o" % (target_build_dirname, src)))
    all_build_outs.extend(o_files)

    return _create_clang_module_build_info(
        module_name = module_name,
        modulemap = out_modulemap,
        o_files = o_files,
        hdrs = public_hdrs,
        build_dir = target_build_dirname,
        all_build_outs = all_build_outs,
        other_outs = other_outs,
        copy_infos = copy_infos,
    )

def _create_clang_module(clang_module_build_info):
    return create_clang_module(
        module_name = clang_module_build_info.module_name,
        o_files = clang_module_build_info.o_files,
        hdrs = clang_module_build_info.hdrs,
        modulemap = clang_module_build_info.modulemap,
        all_outputs = clang_module_build_info.all_build_outs + clang_module_build_info.other_outs,
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

    hdr_file = ctx.actions.declare_file("%s/%s-Swift.h" % (target_build_dirname, target_name))
    all_build_outs.append(hdr_file)

    for src in target["sources"]:
        o_files.append(ctx.actions.declare_file("%s/%s.o" % (target_build_dirname, src)))
    all_build_outs.extend(o_files)

    return create_swift_module(
        module_name = module_name,
        o_files = o_files,
        swiftdoc = swiftdoc,
        swiftmodule = swiftmodule,
        swiftsourceinfo = swiftsourceinfo,
        hdrs = [hdr_file],
        all_outputs = all_build_outs,
    )

def _spm_package_impl(ctx):
    build_output_dirname = "spm_build"
    build_output_dir = ctx.actions.declare_directory(build_output_dirname)
    output_dir_path = build_output_dir.dirname

    all_build_outs = []

    # Toolchain info
    # The swift_worker is typically xcrun.
    swift_toolchain = ctx.attr._toolchain[SwiftToolchainInfo]
    swift_worker = swift_toolchain.swift_worker

    # Parse the package description JSON.
    pkg_desc = pds.parse_json(ctx.attr.package_description_json)

    # GH005: Figure out how to determine the arch part of the directory (e.g. x86_64-apple-macosx).
    build_config_dirname = "%s/x86_64-apple-macosx/%s" % (build_output_dirname, ctx.attr.configuration)

    modulemap_dir_path = "%s/modulemaps" % (output_dir_path)

    targets = pds.library_targets(pkg_desc)

    swift_module_infos = []
    clang_module_build_infos = []
    copy_infos = []
    for target in targets:
        module_type = target["module_type"]
        if module_type == "SwiftTarget":
            swift_module_info = _declare_swift_target_files(ctx, target, build_config_dirname)
            swift_module_infos.append(swift_module_info)
            all_build_outs.extend(swift_module_info.all_outputs)
        if module_type == "ClangTarget":
            clang_module_build_info = _declare_clang_target_files(
                ctx,
                target,
                build_config_dirname,
                modulemap_dir_path,
            )
            clang_module_build_infos.append(clang_module_build_info)
            all_build_outs.extend(clang_module_build_info.all_build_outs)
            copy_infos.extend(clang_module_build_info.copy_infos)

    other_run_inputs = []
    run_args = ctx.actions.args()
    run_args.add_all([
        swift_worker,
        ctx.attr.configuration,
        ctx.attr.package_path,
        build_output_dir.path,
    ])
    for ci in copy_infos:
        run_args.add_all([ci.src, ci.dest])
        other_run_inputs.append(ci.src)

    ctx.actions.run(
        inputs = ctx.files.srcs + other_run_inputs,
        tools = [swift_worker],
        outputs = [build_output_dir] + all_build_outs,
        arguments = [run_args],
        executable = ctx.executable._spm_build_tool,
        progress_message = "Building Swift package (%s) using SPM." % (ctx.attr.package_path),
    )

    clang_module_infos = [_create_clang_module(cmbi) for cmbi in clang_module_build_infos]

    all_outputs = []
    for smi in swift_module_infos:
        all_outputs.extend(smi.all_outputs)
    for cmi in clang_module_infos:
        all_outputs.extend(cmi.all_outputs)

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
    "clang_module_headers": attr.string_list_dict(
        doc = "A dictionary where the keys are target names and the values are public header paths.",
    ),
    "_modulemap_tpl": attr.label(
        allow_single_file = True,
        default = "//spm/internal:module.modulemap.tpl",
    ),
    "_spm_build_tool": attr.label(
        executable = True,
        cfg = "exec",
        default = Label("//spm/internal:exec_spm_build"),
    ),
}

spm_package = rule(
    implementation = _spm_package_impl,
    attrs = dicts.add(
        _attrs,
        swift_common.toolchain_attrs(),
    ),
    doc = "Builds the specified Swift package.",
)
