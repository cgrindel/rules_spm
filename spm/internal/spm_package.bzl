load(":package_descriptions.bzl", "module_types", pds = "package_descriptions")
load(":providers.bzl", "SPMPackageInfo", "SPMPackagesInfo", "providers")
load(":spm_common.bzl", "spm_common")
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_skylib//lib:paths.bzl", "paths")
load("@build_bazel_rules_swift//swift:swift.bzl", "SwiftToolchainInfo", "swift_common")

# MARK: - Swift Module Info

def _declare_swift_target_files(ctx, target, build_config_path):
    all_build_outs = []
    o_files = []

    target_name = target["name"]
    module_name = target["c99name"]

    swiftdoc = ctx.actions.declare_file("%s/%s.swiftdoc" % (build_config_path, target_name))
    swiftmodule = ctx.actions.declare_file("%s/%s.swiftmodule" % (build_config_path, target_name))
    swiftsourceinfo = ctx.actions.declare_file("%s/%s.swiftsourceinfo" % (build_config_path, target_name))
    all_build_outs.extend([swiftdoc, swiftmodule, swiftsourceinfo])

    target_build_dirname = "%s/%s.build" % (build_config_path, target_name)

    hdr_file = ctx.actions.declare_file("%s/%s-Swift.h" % (target_build_dirname, target_name))
    all_build_outs.append(hdr_file)

    for src in target["sources"]:
        o_files.append(ctx.actions.declare_file("%s/%s.o" % (target_build_dirname, src)))
    all_build_outs.extend(o_files)

    return providers.swift_module(
        module_name = module_name,
        o_files = o_files,
        swiftdoc = swiftdoc,
        swiftmodule = swiftmodule,
        swiftsourceinfo = swiftsourceinfo,
        hdrs = [hdr_file],
        all_outputs = all_build_outs,
    )

# MARK: - Package Build Info

def _create_package_build_info(pkg_desc, pkg_info, build_outs, copy_infos):
    return struct(
        pkg_desc = pkg_desc,
        pkg_info = pkg_info,
        build_outs = build_outs,
        copy_infos = copy_infos,
    )

def _gather_package_build_info(ctx, pkg_desc, build_config_path):
    build_outs = []
    copy_infos = []
    swift_modules = []
    clang_modules = []
    pkg_name = pkg_desc["name"]

    exported_targets = pds.exported_library_targets(pkg_desc)
    for target in exported_targets:
        if pds.is_swift_target(target):
            swift_module_info = _declare_swift_target_files(ctx, target, build_config_path)
            swift_modules.append(swift_module_info)
            build_outs.extend(swift_module_info.all_outputs)

        elif pds.is_clang_target(target):
            # TODO: IMPLEMENT ME!
            pass

    pkg_info = SPMPackageInfo(
        name = pkg_name,
        swift_modules = swift_modules,
        clang_modules = clang_modules,
    )

    return _create_package_build_info(pkg_desc, pkg_info, build_outs, copy_infos)

# MARK: - Build Packages

def _build_all_pkgs(ctx, pkg_build_infos):
    # Toolchain info
    # The swift_worker is typically xcrun.
    swift_toolchain = ctx.attr._toolchain[SwiftToolchainInfo]
    swift_worker = swift_toolchain.swift_worker

    build_output_dir = ctx.actions.declare_directory(spm_common.build_dirname)

    all_build_outs = []
    copy_infos = []
    for pbi in pkg_build_infos:
        all_build_outs.extend(pbi.build_outs)
        copy_infos.extend(pbi.copy_infos)

    # other_run_inputs = []
    run_args = ctx.actions.args()
    run_args.add_all([
        swift_worker,
        ctx.attr.configuration,
        ctx.attr.package_path,
        build_output_dir.path,
    ])
    for ci in copy_infos:
        run_args.add_all([ci.src, ci.dest])
        # other_run_inputs.append(ci.src)

    ctx.actions.run(
        # inputs = ctx.files.srcs + other_run_inputs,
        inputs = ctx.files.srcs,
        tools = [swift_worker],
        outputs = [build_output_dir] + all_build_outs,
        arguments = [run_args],
        executable = ctx.executable._spm_build_tool,
        progress_message = "Building Swift package (%s) using SPM." % (ctx.attr.package_path),
    )

# MARK: - Rule Implementation

def _spm_package_impl(ctx):
    # Parse the package description JSON.
    pkg_descs_dict = pds.parse_json(ctx.attr.package_descriptions_json)

    # GH005: Figure out how to determine the arch part of the directory (e.g. x86_64-apple-macosx).
    build_config_path = paths.join(
        spm_common.build_dirname,
        "x86_64-apple-macosx",
        ctx.attr.configuration,
    )

    # Collect information about the SPM packages
    pkg_build_infos = []
    for pkg_name in pkg_descs_dict:
        if pkg_name == pds.root_pkg_name:
            continue
        pkg_desc = pkg_descs_dict[pkg_name]
        pkg_build_info = _gather_package_build_info(
            ctx,
            pkg_desc,
            build_config_path,
        )
        pkg_build_infos.append(pkg_build_info)

    # Execute the build
    _build_all_pkgs(ctx, pkg_build_infos)

    # TODO: Populate all_outputs.
    all_outputs = []
    return [
        DefaultInfo(files = depset(all_outputs)),
        SPMPackagesInfo(
            packages = [pbi.pkg_info for pbi in pkg_build_infos],
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
    "package_descriptions_json": attr.string(
        mandatory = True,
        doc = "JSON string which describes the package (i.e. swift package describe --type json).",
    ),
    "package_path": attr.string(
        doc = "Directory which contains the Package.swift (i.e. swift build --package-path VALUE).",
    ),
    "clang_module_headers": attr.string_list_dict(
        doc = "A `dict` where the keys are target names and the values are public header paths.",
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
