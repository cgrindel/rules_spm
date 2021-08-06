load("//spm/internal/modulemap_parser:declarations.bzl", dts = "declaration_types")
load("//spm/internal/modulemap_parser:parser.bzl", "parser")
load(":package_descriptions.bzl", "module_types", pds = "package_descriptions")
load(":packages.bzl", "packages")
load(":files.bzl", "files")
load("@bazel_skylib//lib:paths.bzl", "paths")

# MARK: - Module Declaration Functions

_spm_swift_module_tpl = """
spm_swift_module(
    name = "%s",
    package = "@%s//:build",
)
"""

_spm_clang_module_tpl = """
spm_clang_module(
    name = "%s",
    package = "@%s//:build",
    hdrs = [
%s
    ],
)
"""

def _create_spm_swift_module_decl(repository_ctx, target):
    """Returns the spm_swift_module declaration for this Swift target.
    """
    module_name = target["c99name"]
    return _spm_swift_module_tpl % (module_name, repository_ctx.attr.name)

def _create_spm_clang_module_decl(repository_ctx, custom_hdrs_dict, target):
    # module_name = target["c99name"]
    # src_path = paths.join(pkg_root_path, target["path"])
    # module_paths = _list_files_under(repository_ctx, src_path)
    # custom_hdrs = []

    # modulemap_paths = [p for p in module_paths if _is_modulemap_path(p)]
    # modulemap_paths_len = len(modulemap_paths)
    # if modulemap_paths_len > 1:
    #     fail("Found more than one module.modulemap file. %" % (modulemap_paths))

    # # If a modulemap was provided, read it for header info.
    # # Otherwise, use all of the header files under the "include" directory.
    # if modulemap_paths_len == 1:
    #     hdr_paths = _get_hdr_paths_from_modulemap(repository_ctx, module_paths, modulemap_paths[0])
    #     custom_hdrs = hdr_paths
    # else:
    #     hdr_paths = [p for p in module_paths if _is_include_hdr_path(p)]

    # # deps_str = _create_deps_str(target)
    # hdrs_str = _create_hdrs_str(hdr_paths)

    # return _spm_clang_module_tpl % (module_name, hdrs_str), custom_hdrs
    pass

def _generate_bazel_pkg(repository_ctx, custom_hdrs_dict, pkg_desc):
    pkg_name = pkg_desc["name"]
    bld_path = "%s/BUILD.bazel" % (pkg_name)
    exported_targets = pds.exported_library_targets(pkg_desc)

    module_decls = []
    for target in exported_targets:
        if pds.is_clang_target(target):
            module_decls.append(_create_spm_clang_module_decl(repository_ctx, custom_hdrs_dict, target))
        else:
            module_decls.append(_create_spm_swift_module_decl(repository_ctx, target))

    bld_content = _bazel_pkg_hdr + "".join(module_decls)
    repository_ctx.file(bld_path, content = bld_content, executable = False)

# MARK: - Other Stuff

_bazel_pkg_hdr = """
load("@cgrindel_rules_spm//spm:spm.bzl", "spm_swift_module", "spm_clang_module")

"""

def _get_dep_pkg_desc(repository_ctx, pkg_dep):
    """Returns the name and the package description for the specified dependency.

    Args:
        repository_ctx: A `repository_ctx`.
        pkg_dep: A `dict` representing a dependency from an SPM package description JSON.

    Returns:
        A `tuple` where the firt item is the name of the dependency and the second
        is the package description for the dependency.
    """
    dep_name = pds.dependency_name(pkg_dep)
    dep_checkout_path = paths.join(_checkouts_path, dep_name)
    dep_pkg_desc = pds.get(repository_ctx, working_directory = dep_checkout_path)
    return (dep_name, dep_pkg_desc)

# MARK: - Clang Custom Headers Functions

def _is_modulemap_path(path):
    basename = paths.basename(path)
    dirname = paths.basename(paths.dirname(path))
    return dirname == "include" and basename == "module.modulemap"

def _get_hdr_paths_from_modulemap(repository_ctx, module_paths, modulemap_path):
    modulemap_str = repository_ctx.read(modulemap_path)
    decls, err = parser.parse(modulemap_str)
    if err != None:
        fail("Errors parsing the %s. %s" % (modulemap_path, err))

    module_decls = [d for d in decls if d.decl_type == dts.module]
    module_decls_len = len(module_decls)
    if module_decls_len == 0:
        fail("No module declarations were found in %s." % (modulemap_path))
    if module_decls_len > 1:
        fail("Expected a single module definition but found %s." % (module_decls_len))
    module_decl = module_decls[0]

    modulemap_dirname = paths.dirname(modulemap_path)
    hdrs = []
    for cdecl in module_decl.members:
        if cdecl.decl_type == dts.single_header and not cdecl.private and not cdecl.textual:
            # Resolve the path relative to the modulemap
            hdr_path = paths.join(modulemap_dirname, cdecl.path)
            normalized_hdr_path = paths.normalize(hdr_path)
            hdrs.append(normalized_hdr_path)

    return hdrs

def _get_custom_hdrs_for_clang_target(repository_ctx, target, pkg_root_path = ""):
    src_path = paths.join(pkg_root_path, target["path"])
    module_paths = files.list_files_under(repository_ctx, src_path)
    modulemap_paths = [p for p in module_paths if _is_modulemap_path(p)]
    modulemap_paths_len = len(modulemap_paths)
    if modulemap_paths_len == 0:
        return []
    elif modulemap_paths_len > 1:
        fail("Found more than one module.modulemap file. %" % (modulemap_paths))
    return _get_hdr_paths_from_modulemap(repository_ctx, module_paths, modulemap_paths[0])

# MARK: - Root BUILD.bazel Generation

def _create_hdrs_str(hdr_paths):
    hdrs = ["        \"%s\"," % (p) for p in hdr_paths]
    return "\n".join(hdrs)

def _create_clang_module_headers_entry(target_name, hdr_paths):
    entry_tpl = """\
        "%s": [
    %s
        ],"""
    hdrs_str = _create_hdrs_str(hdr_paths)
    return entry_tpl % (target_name, hdrs_str)

def _create_clang_module_headers(hdrs_dict):
    entries = [_create_clang_module_headers_entry(k, hdrs_dict[k]) for k in hdrs_dict]
    return "\n".join(entries)

def _generate_root_bld_file(repository_ctx, pkg_descriptions, custom_hdrs_dict):
    substitutions = {
        "{spm_repos_name}": repository_ctx.attr.name,
        "{pkg_descs_json}": json.encode_indent(pkg_descriptions, indent = "  "),
        "{clang_module_headers}": _create_clang_module_headers(custom_hdrs_dict),
    }
    repository_ctx.template(
        "BUILD.bazel",
        repository_ctx.attr._root_build_tpl,
        substitutions = substitutions,
        executable = False,
    )

# MARK: - Package.swift Generation

_package_tpl = """\
.package(name: "%s", url: "%s", from: "%s")\
"""

_target_dep_tpl = """\
.product(name: "%s", package: "%s")\
"""

_platforms_tpl = """\
  platforms: [
%s
  ],
"""

def _generate_package_swift_file(repository_ctx, pkgs):
    swift_platforms = ""
    if len(repository_ctx.attr.platforms) > 0:
        swift_platforms = _platforms_tpl % (
            ",\n".join(["    %s" % (p) for p in repository_ctx.attr.platforms])
        )

    pkg_deps = [_package_tpl % (pkg.spm_name, pkg.url, pkg.from_version) for pkg in pkgs]
    target_deps = [_target_dep_tpl % (pname, pkg.spm_name) for pkg in pkgs for pname in pkg.products]
    substitutions = {
        "{swift_tools_version}": repository_ctx.attr.swift_version,
        "{swift_platforms}": swift_platforms,
        "{package_dependencies}": ",\n".join(["    %s" % (d) for d in pkg_deps]),
        "{target_dependencies}": ",\n".join(["      %s" % (d) for d in target_deps]),
    }
    repository_ctx.template(
        "Package.swift",
        repository_ctx.attr._package_swift_tpl,
        substitutions = substitutions,
        executable = False,
    )

# MARK: - Rule Implementation

_build_dirname = "spm_build"
_checkouts_path = paths.join(_build_dirname, "checkouts")

def _configure_spm_repository(repository_ctx):
    # Resolve/fetch the dependencies.
    resolve_result = repository_ctx.execute(
        ["swift", "package", "resolve", "--build-path", _build_dirname],
    )
    if resolve_result.return_code != 0:
        fail("Resolution of SPM packages for %s failed.\n%s" % (
            repository_ctx.attr.name,
            resolve_result.stderr,
        ))

    pkg_descriptions = dict()
    custom_hdrs_dict = dict()

    root_pkg_desc = pds.get(repository_ctx)
    pkg_descriptions[pds.root_pkg_name] = root_pkg_desc

    # Collect the package descriptions for the dependencies
    for pkg_dep in root_pkg_desc["dependencies"]:
        # Get the package description
        dep_name, dep_pkg_desc = _get_dep_pkg_desc(repository_ctx, pkg_dep)
        pkg_descriptions[dep_name] = dep_pkg_desc

        # Look for custom header declarations in the clang targets
        clang_targets = [t for t in pds.library_targets(dep_pkg_desc) if pds.is_clang_target(t)]
        for clang_target in clang_targets:
            custom_hdrs = _get_custom_hdrs_for_clang_target(
                repository_ctx,
                clang_target,
                pkg_root_path = paths.join(_checkouts_path, dep_name),
            )
            if custom_hdrs == []:
                continue
            dep_target_name = "%s/%s" % (dep_name, clang_target["name"])
            custom_hdrs_dict[dep_target_name] = custom_hdrs

        # Generate Bazel targets for the library products
        _generate_bazel_pkg(repository_ctx, custom_hdrs_dict, dep_pkg_desc)

    # Write BUILD.bazel file.
    _generate_root_bld_file(repository_ctx, pkg_descriptions, custom_hdrs_dict)

def _spm_repositories_impl(repository_ctx):
    pkgs = [packages.from_json(j) for j in repository_ctx.attr.dependencies]

    # DEBUG BEGIN
    print("*** CHUCK pkgs: ")
    for idx, item in enumerate(pkgs):
        print("*** CHUCK", idx, ":", item)

    # DEBUG END

    # Generate Package.swift
    _generate_package_swift_file(repository_ctx, pkgs)

    # Create barebones source files
    repository_ctx.file(
        "Sources/Placeholder/Placeholder.swift",
        content = "# Intentionally blank",
        executable = False,
    )

    # Configure the SPM package
    _configure_spm_repository(repository_ctx)

spm_repositories = repository_rule(
    implementation = _spm_repositories_impl,
    attrs = {
        "dependencies": attr.string_list(
            mandatory = True,
            doc = "List of JSON strings specifying the SPM packages to load.",
        ),
        "swift_version": attr.string(
            default = "5.3",
            doc = """\
            The version of Swift that will be declared in the placeholder/uber Swift package.\
            """,
        ),
        "platforms": attr.string_list(
            doc = """\
            The platforms to declare in the placeholder/uber Swift package. \
            (e.g. .macOS(.v10_15))\
            """,
        ),
        "_package_swift_tpl": attr.label(
            default = "//spm/internal:Package.swift.tpl",
        ),
        "_root_build_tpl": attr.label(
            default = "//spm/internal:root.BUILD.bazel.tpl",
        ),
    },
)

spm_pkg = packages.pkg_json
