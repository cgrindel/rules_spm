load(":package_descriptions.bzl", "module_types", pds = "package_descriptions")
load(":providers.bzl", "SPMPackageInfo", "SPMPackagesInfo", "providers")
load(":packages.bzl", "packages")
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

def _create_pkg_build_info(pkg_desc, pkg_info, build_outs, copy_infos, build_inputs = []):
    return struct(
        pkg_desc = pkg_desc,
        pkg_info = pkg_info,
        build_outs = build_outs,
        copy_infos = copy_infos,
        build_inputs = build_inputs,
    )

def _update_pkg_build_info(pkg_build_info, copy_infos = [], build_inputs = []):
    new_copy_infos = list(pkg_build_info.copy_infos)
    new_copy_infos.extend(copy_infos)

    new_build_inputs = list(pkg_build_info.build_inputs)
    new_build_inputs.extend(build_inputs)

    return _create_pkg_build_info(
        pkg_build_info.pkg_desc,
        pkg_build_info.pkg_info,
        pkg_build_info.build_outs,
        new_copy_infos,
        build_inputs = new_build_inputs,
    )

def _gather_package_build_info(ctx, pkg_desc, build_config_path, product_names):
    build_outs = []
    copy_infos = []
    swift_modules = []
    clang_modules = []
    pkg_name = pkg_desc["name"]

    # Declare outputs for the modules that will be used
    exported_targets = pds.exported_library_targets(pkg_desc, product_names = product_names)
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

    return _create_pkg_build_info(pkg_desc, pkg_info, build_outs, copy_infos)

# MARK: - Clang Target Customization

def _customize_clang_modulemap_and_hdrs(
        ctx,
        target_name,
        module_name,
        public_hdrs,
        build_config_path,
        modulemap_dir_path):
    copy_infos = []
    build_inputs = []

    if public_hdrs == []:
        fail("A clang target must have at least one public header. target: %s" % (
            target_name,
        ))

    target_build_dirname = "%s/%s.build" % (build_config_path, target_name)
    target_modulemap_dirname = "%s/%s.build" % (modulemap_dir_path, target_name)

    # Copy all of the public headers to the output during the SPM build
    for hdr in public_hdrs:
        out_hdr = ctx.actions.declare_file("%s/%s" % (target_build_dirname, paths.basename(hdr)))
        src_hdr = paths.join(ctx.attr.package_path, hdr)
        copy_infos.append(providers.copy_info(src_hdr, out_hdr))

    # The gen_modulemap is where the generated modulemap will initially be written.
    # The out_modulemap is where the generated modulemap will be copied after the SPM build.
    gen_modulemap = ctx.actions.declare_file("%s/module.modulemap" % (target_modulemap_dirname))
    build_inputs.append(gen_modulemap)
    out_modulemap = ctx.actions.declare_file("%s/module.modulemap" % (target_build_dirname))

    # The module.modulemap template uses an umbrella header declaration. This means that every header
    # file in the directory or subdirectory of the specified header will be used as a public. Since
    # we will be copying all of the header files for the target to the same directory, we can get
    # away with specifying a single umbrella header.
    umbrella_hdr = public_hdrs[0]
    substitutions = {
        "{spm_module_name}": module_name,
        "{spm_module_header}": paths.basename(umbrella_hdr),
    }
    ctx.actions.expand_template(
        template = ctx.file._modulemap_tpl,
        output = gen_modulemap,
        substitutions = substitutions,
    )
    copy_infos.append(providers.copy_info(gen_modulemap, out_modulemap))

    return copy_infos, build_inputs

# MARK: - Build Packages

def _build_all_pkgs(ctx, pkg_build_infos_dict):
    # Toolchain info
    # The swift_worker is typically xcrun.
    swift_toolchain = ctx.attr._toolchain[SwiftToolchainInfo]
    swift_worker = swift_toolchain.swift_worker

    build_output_dir = ctx.actions.declare_directory(spm_common.build_dirname)

    all_build_outs = []
    copy_infos = []
    build_inputs = []
    for pkg_name in pkg_build_infos_dict:
        pbi = pkg_build_infos_dict[pkg_name]
        all_build_outs.extend(pbi.build_outs)
        copy_infos.extend(pbi.copy_infos)
        build_inputs.extend(pbi.build_inputs)

    run_args = ctx.actions.args()
    run_args.add_all([
        swift_worker,
        ctx.attr.configuration,
        ctx.attr.package_path,
        build_output_dir.path,
    ])
    for ci in copy_infos:
        run_args.add_all([ci.src, ci.dest])
        all_build_outs.append(ci.dest)

    ctx.actions.run(
        inputs = ctx.files.srcs + build_inputs,
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
    pkgs = packages.from_json(ctx.attr.dependencies_json)

    # GH005: Figure out how to determine the arch part of the directory (e.g. x86_64-apple-macosx).
    build_config_path = paths.join(
        spm_common.build_dirname,
        "x86_64-apple-macosx",
        ctx.attr.configuration,
    )

    # Collect information about the SPM packages
    pkg_build_infos_dict = dict()
    for pkg_name in pkg_descs_dict:
        if pkg_name == pds.root_pkg_name:
            continue
        pkg = spm_common.get_pkg(pkgs, pkg_name)
        pkg_desc = pkg_descs_dict[pkg_name]
        pkg_build_infos_dict[pkg_name] = _gather_package_build_info(
            ctx,
            pkg_desc,
            build_config_path,
            pkg.products,
        )

    # Customize the headers and modulemap files for all clang targets.
    # TODO: Do I need to declare a directory and put the modulemaps dir under it?
    modulemap_dir_path = "modulemaps"
    for pkg_name_target in ctx.attr.clang_module_headers:
        src_hdrs = ctx.attr.clang_module_headers[pkg_name_target]
        pkg_name, target_name = spm_common.split_clang_hdrs_key(pkg_name_target)
        pkg_build_info = pkg_build_infos_dict[pkg_name]
        target_desc = pds.get_target(pkg_build_info.pkg_desc, target_name)
        module_name = target_desc["c99name"]
        copy_infos, build_inputs = _customize_clang_modulemap_and_hdrs(
            ctx,
            target_name,
            module_name,
            src_hdrs,
            build_config_path,
            modulemap_dir_path,
        )
        pkg_build_infos_dict[pkg_name] = _update_pkg_build_info(
            pkg_build_infos_dict[pkg_name],
            copy_infos = copy_infos,
            build_inputs = build_inputs,
        )

    # Execute the build
    _build_all_pkgs(ctx, pkg_build_infos_dict)

    # TODO: Populate all_outputs.
    all_outputs = []
    return [
        DefaultInfo(files = depset(all_outputs)),
        SPMPackagesInfo(
            packages = [pkg_build_infos_dict[pkg_name].pkg_info for pkg_name in pkg_build_infos_dict],
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
    "dependencies_json": attr.string(
        mandatory = True,
        doc = """"\
        JSON string describing the dependencies to expose\
        (e.g. see dependencies in spm_repositories)\
        """,
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
