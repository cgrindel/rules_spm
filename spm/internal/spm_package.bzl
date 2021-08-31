load(":package_descriptions.bzl", "module_types", pds = "package_descriptions")
load(":packages.bzl", "packages")
load(":platforms.bzl", "platforms")
load(":providers.bzl", "SPMBuildInfo", "SPMPackageInfo", "SPMPackagesInfo", "SPMPlatformInfo", "providers")
load(":references.bzl", ref_types = "reference_types", refs = "references")
load(":spm_common.bzl", "spm_common")
load("spm_toolchain.bzl", "SPM_TOOLCHAIN_TYPE")
load(":swift_toolchains.bzl", "swift_toolchains")
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_skylib//lib:paths.bzl", "paths")

# MARK: - Swift Module Info

def _declare_swift_target_files(ctx, target, build_config_path):
    """Declares the outputs for a Swift module and returns a struct value 
    describing the Swift module.

    Args:
        ctx: A `ctx` instance.
        target: A target `dict` from the package description.
        build_config_path: A `string` specifying the build output path.

    Returns:
        A `struct` value as returned from `providers.swift_module()`.
    """
    all_build_outs = []
    o_files = []

    target_name = target["name"]
    module_name = target["name"]

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

# MARK: - Clang Module Info

def _declare_clang_target_files(
        ctx,
        target,
        build_config_path,
        clang_custom_info):
    """Declares the outputs for a clang module and returns a struct value 
    describing the clang module.

    Args:
        ctx: A `ctx` instance.
        target: A target `dict` from the package description.
        build_config_path: A `string` specifying the build output path.
        clang_custom_info: A `struct` value as created by
                           `_create_clang_custom_info`.

    Returns:
        A `struct` value as returned from `providers.clang_module()`.
    """
    all_outputs = []
    o_files = []

    target_name = target["name"]
    module_name = target["name"]

    target_build_dirname = "%s/%s.build" % (build_config_path, target_name)

    # Declare the Mach-O files.
    for src in target["sources"]:
        o_files.append(ctx.actions.declare_file("%s/%s.o" % (target_build_dirname, src)))
    all_outputs.extend(o_files)

    return providers.clang_module(
        module_name = module_name,
        o_files = o_files,
        hdrs = clang_custom_info.hdrs,
        modulemap = clang_custom_info.modulemap,
        all_outputs = all_outputs,
    )

# MARK: - System Library Module Info

def _declare_system_library_target_files(ctx, pkg_name, target):
    target_name = target["name"]
    module_name = target["name"]

    target_path = paths.join(pkg_name, target["path"])
    modulemap = None
    c_files = []
    hdrs = []
    for f in ctx.files.srcs:
        if f.dirname.find(target_path) == -1:
            continue

        if f.basename == "module.modulemap":
            modulemap = f
        elif f.extension == "h":
            hdrs.append(f)
        elif f.extension == "c":
            c_files.append(f)

    if c_files == []:
        fail("Expected to find c files for target %s in package %s." % (target_name, pkg_name))
    if hdrs == []:
        fail("Expected to find header files for target %s in package %s." % (target_name, pkg_name))

    return providers.system_library_module(
        module_name = module_name,
        c_files = c_files,
        hdrs = hdrs,
        modulemap = modulemap,
        all_outputs = [],
    )

# MARK: - Package Build Info

def _create_pkg_build_info(pkg_desc, pkg_info, build_outs):
    """Creates a struct representing the build information for a Swift package.

    Args:
        pkg_desc: A `dict` representing the package descprtion JSON.
        pkg_info: A `SPMPackageInfo` value.
        build_outs: A `list` of declared outputs (`File`) for the package.

    Returns:
        A `struct` value representing a Swift package's build information.
    """
    return struct(
        pkg_desc = pkg_desc,
        pkg_info = pkg_info,
        build_outs = build_outs,
    )

def _gather_package_build_info(
        ctx,
        build_config_path,
        clang_custom_infos_dict,
        pkg_desc,
        target_refs):
    """Gathers build information for a Swift package.

    Args:
        ctx: A `ctx` instance.
        build_config_path: A `string` specifying the build output path.
        clang_custom_infos_dict: A `dict` where the keys are clang target names
                                 for this package and the values are a `list`
                                 of public headers.
        pkg_desc: A `dict` representing the package descprtion JSON.
        target_refs: A `list` of target references (`string`) that are
                     dependencies for the package.

    Returns:
        A `struct` value as created by `_create_pkg_build_info()` representing
        the build information for the Swift package.
    """
    build_outs = []
    swift_modules = []
    clang_modules = []
    system_library_modules = []
    pkg_name = pkg_desc["name"]

    # Declare outputs for the targets that will be used
    for target_ref in target_refs:
        ref_type, pname, target_name = refs.split(target_ref)
        target = pds.get_target(pkg_desc, target_name)

        if pds.is_swift_module(target):
            swift_module_info = _declare_swift_target_files(ctx, target, build_config_path)
            swift_modules.append(swift_module_info)
            build_outs.extend(swift_module_info.all_outputs)

        elif pds.is_clang_module(target):
            clang_module_info = _declare_clang_target_files(
                ctx,
                target,
                build_config_path,
                clang_custom_infos_dict[target["name"]],
            )
            clang_modules.append(clang_module_info)
            build_outs.extend(clang_module_info.all_outputs)

        elif pds.is_system_library_module(target):
            system_library_module_info = _declare_system_library_target_files(
                ctx,
                pname,
                target,
            )
            system_library_modules.append(system_library_module_info)
            build_outs.extend(system_library_module_info.all_outputs)

    pkg_info = SPMPackageInfo(
        name = pkg_name,
        swift_modules = swift_modules,
        clang_modules = clang_modules,
        system_library_modules = system_library_modules,
    )

    return _create_pkg_build_info(pkg_desc, pkg_info, build_outs)

# MARK: - Clang Target Customization

def _create_clang_custom_info(target_name, hdrs = [], modulemap = None):
    """Creates a struct value representing the customization info for a clange
    target.

    Args:
        target_name: The target name as a `string`.
        hdrs: A `list` of declared outputs (`File`) for the public headers.
        modulemap: The declared output for the module's `module.modulemap`
                   file.

    Returns:
        A `struct` value.
    """
    return struct(
        target_name = target_name,
        hdrs = hdrs,
        modulemap = modulemap,
    )

def _customize_clang_modulemap_and_hdrs(
        ctx,
        target_name,
        module_name,
        public_hdrs,
        build_config_path,
        modulemap_dir_path):
    """Customize the output for clang modules.

    To ensure that clang modules link properly, the public headers are copied
    to the output directory and a custom modulemap is written pointing at the
    copied public headers.

    Args:
        ctx: A `ctx` instance.
        target_name: The name of the clang target as a `string`.
        module_name: The name of the clang module as a `string`.
        public_hdrs: A `list` of `string` values specifying the path
                     to the public headers in the source tree.
        build_config_path: A `string` specifying the build output path.
        modulemap_dir_path: A `string` specifying the path where custom
                            modulemaps will be generated.

    Returns:
        A `tuple` where the first item is a `struct` as created by
        `_create_clang_custom_info()`, the second item is a `list` of
        `struct` values created by `providers.copy_info()` and the
        third item is a `list` of items that should be specified as
        inputs into the SPM build step.
    """
    out_hdrs = []
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
        out_hdrs.append(out_hdr)
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

    clang_custom_info = _create_clang_custom_info(
        target_name,
        hdrs = out_hdrs,
        modulemap = out_modulemap,
    )
    return clang_custom_info, copy_infos, build_inputs

# MARK: - Build Packages

def _build_all_pkgs(ctx, pkg_build_infos_dict, copy_infos, build_inputs):
    """Executes the Swift pacakage manager build.

    Args:
        ctx: A `ctx` instance.
        pkg_build_infos_dict: A `dict` of package build information `dict`
                              values indexed by package name.
        copy_infos: A `list` of `struct` values as created by
                    `providers.copy_info()`.
        build_inputs: A `list` of inputs that are specified on the build
                      action.

    Returns:
        A `list` of declared build outputs.
    """

    # SPM Toolchain Info
    spm_build_info = _get_spm_build_info(ctx)

    build_output_dir = ctx.actions.declare_directory(spm_common.build_dirname)

    all_build_outs = [build_output_dir]
    for pkg_name in pkg_build_infos_dict:
        pbi = pkg_build_infos_dict[pkg_name]
        all_build_outs.extend(pbi.build_outs)

    run_args = ctx.actions.args()
    run_args.add_all([
        "--build-config",
        ctx.attr.configuration,
        "--package-path",
        ctx.attr.package_path,
        "--build-path",
        build_output_dir.path,
        "--target_triple",
        spm_build_info.target_triple,
        "--sdk_name",
        spm_build_info.sdk_name,
    ])
    for ci in copy_infos:
        run_args.add_all([ci.src, ci.dest])
        all_build_outs.append(ci.dest)

    ctx.actions.run(
        inputs = ctx.files.srcs + build_inputs,
        outputs = all_build_outs,
        arguments = [run_args],
        executable = spm_build_info.build_tool,
        progress_message = "Building Swift package (%s) for %s using SPM." % (
            ctx.attr.package_path,
            spm_build_info.target_triple,
        ),
    )

    return all_build_outs

# MARK: - Toolchain Info

def _get_spm_build_info(ctx):
    return ctx.toolchains[SPM_TOOLCHAIN_TYPE].spm_build_info

# MARK: - Rule Implementation

def _get_build_config_path(ctx):
    # According to https://github.com/apple/swift-package-manager/blob/ce50cb0de101c2d9a5742aaf70efc7c21e8f249b/Sources/Workspace/Destination.swift#L29,
    # it looks like the build config directory is based upon the triple
    # with a format of <arch><sub>-<vendor>-<sys>-<abi>, where:
    #
    # arch = x86_64, i386, arm, thumb, mips, etc.
    # sub = for ex. on ARM: v5, v6m, v7a, v7m, etc.
    # vendor = pc, apple, nvidia, ibm, etc.
    # sys = none, linux, win32, darwin, cuda, etc.
    # abi = eabi, gnu, android, macho, elf, etc.
    #
    # See: https://clang.llvm.org/docs/CrossCompilation.html#target-triple
    # Example arch-vendor-os: "x86_64-apple-macosx"
    spm_build_info = _get_spm_build_info(ctx)
    spm_platform_info = spm_build_info.spm_platform_info
    arch_vendor_os = "-".join([
        spm_platform_info.arch,
        spm_platform_info.vendor,
        spm_platform_info.os,
    ])
    return paths.join(
        spm_common.build_dirname,
        arch_vendor_os,
        ctx.attr.configuration,
    )

def _spm_package_impl(ctx):
    # Parse the package description JSON.
    pkg_descs_dict = pds.parse_json(ctx.attr.package_descriptions_json)
    pkgs = packages.from_json(ctx.attr.dependencies_json)

    build_config_path = _get_build_config_path(ctx)

    # Customize the headers and modulemap files for all clang targets.
    modulemap_dir_path = "modulemaps"
    copy_infos = []
    build_inputs = []
    pkg_clang_custom_infos_dict = {}
    for pkg_name_target in ctx.attr.clang_module_headers:
        src_hdrs = ctx.attr.clang_module_headers[pkg_name_target]
        pkg_name, target_name = spm_common.split_clang_hdrs_key(pkg_name_target)
        pkg_desc = pkg_descs_dict[pkg_name]
        target_desc = pds.get_target(pkg_desc, target_name)
        module_name = target_desc["name"]

        clang_custom_info, target_copy_infos, target_build_inputs = _customize_clang_modulemap_and_hdrs(
            ctx,
            target_name,
            module_name,
            src_hdrs,
            build_config_path,
            modulemap_dir_path,
        )
        clang_custom_infos_dict = pkg_clang_custom_infos_dict.get(pkg_name, default = {})
        clang_custom_infos_dict[target_name] = clang_custom_info
        pkg_clang_custom_infos_dict[pkg_name] = clang_custom_infos_dict
        copy_infos.extend(target_copy_infos)
        build_inputs.extend(target_build_inputs)

    # Collect the
    declared_product_refs = packages.get_product_refs(pkgs)
    dep_target_refs_dict = pds.transitive_dependencies(pkg_descs_dict, declared_product_refs)

    # Collect information about the SPM packages
    pkg_build_infos_dict = dict()
    for pkg_name in pkg_descs_dict:
        if pkg_name == pds.root_pkg_name:
            continue
        target_refs = [tr for tr in dep_target_refs_dict if refs.is_target_ref(tr, for_pkg = pkg_name)]
        if target_refs == []:
            continue
        pkg_desc = pkg_descs_dict[pkg_name]
        clang_custom_infos_dict = pkg_clang_custom_infos_dict.get(pkg_name, default = {})
        pkg_build_infos_dict[pkg_name] = _gather_package_build_info(
            ctx,
            build_config_path,
            clang_custom_infos_dict,
            pkg_desc,
            target_refs,
        )

    # Execute the build
    all_outputs = _build_all_pkgs(ctx, pkg_build_infos_dict, copy_infos, build_inputs)

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
}

spm_package = rule(
    implementation = _spm_package_impl,
    attrs = _attrs,
    doc = "Builds the specified Swift package.",
    toolchains = [SPM_TOOLCHAIN_TYPE],
)
