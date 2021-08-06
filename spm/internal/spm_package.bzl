load(":package_descriptions.bzl", "module_types", pds = "package_descriptions")
load(":providers.bzl", "SPMPackageInfo", "SPMPackagesInfo", "providers")
load(":spm_common.bzl", "spm_common")
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_skylib//lib:paths.bzl", "paths")
load("@build_bazel_rules_swift//swift:swift.bzl", "SwiftToolchainInfo", "swift_common")

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
    pkg_name = pkg_desc["name"]

    # TODO: IMPLEMENT ME!
    swift_modules = []
    clang_modules = []

    pkg_info = SPMPackageInfo(
        name = pkg_name,
        swift_modules = swift_modules,
        clang_modules = clang_modules,
    )

    return _create_package_build_info(pkg_desc, pkg_info, build_outs, copy_infos)

# MARK: - Rule Implementation

def _spm_package_impl(ctx):
    pkg_build_infos = []

    # # Toolchain info
    # # The swift_worker is typically xcrun.
    # swift_toolchain = ctx.attr._toolchain[SwiftToolchainInfo]
    # swift_worker = swift_toolchain.swift_worker

    # Parse the package description JSON.
    pkg_descs_dict = pds.parse_json(ctx.attr.package_descriptions_json)

    # GH005: Figure out how to determine the arch part of the directory (e.g. x86_64-apple-macosx).
    build_config_path = paths.join(
        spm_common.build_dirname,
        "x86_64-apple-macosx",
        ctx.attr.configuration,
    )

    # Collect information about the SPM packages
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
    # TODO: IMPLEMENT ME!
    # _build_all_pkgs(ctx, pkg_build_infos)

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
