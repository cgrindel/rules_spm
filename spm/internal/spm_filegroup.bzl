load(":providers.bzl", "SPMPackagesInfo")
load("@bazel_skylib//lib:paths.bzl", "paths")

def _derive_pkg_name(ctx):
    """Determines the Swift package name from the Bazel package name.

    Args:
        ctx: A `ctx` instance.

    Returns:
        A `string` representing the Swift package name.
    """
    return paths.basename(paths.dirname(ctx.build_file_path))

def _get_pkg_info(pkg_infos, pkg_name):
    """Returns the `SPMPackageInfo` with the specified name from the list
    of `SPMPackageInfo` values.

    Args:
        pkg_infos: A `list` of `SPMPackageInfo` values.
        pkg_name: A `string` representing the name of the desired
                  `SPMPackageInfo`.

    Returns:
        An `SPMPackageInfo` value.
    """
    for pi in pkg_infos:
        if pi.name == pkg_name:
            return pi
    fail("Could not find package with name", pkg_name)

def _get_module_info(pkg_info, module_name):
    """Returns the module information with the specified module name.

    Args:
        pkg_info: An `SPMPackageInfo` value.
        module_name: The module name `string`.

    Returns:
        If the module is a Swift module, a `struct` value as created by
        `providers.swift_module()` is returend. If the module is a clang
        module a `struct` value as created by `providers.clang_module()` is
        returned.
    """
    for module in pkg_info.swift_modules:
        if module.module_name == module_name:
            return module
    for module in pkg_info.clang_modules:
        if module.module_name == module_name:
            return module
    for module in pkg_info.system_library_modules:
        if module.module_name == module_name:
            return module
    fail("Could not find module with name", module_name, "in package", pkg_info.name)

def _spm_filegroup_impl(ctx):
    pkgs_info = ctx.attr.packages[SPMPackagesInfo]

    pkg_name = ctx.attr.package_name
    if pkg_name == "":
        pkg_name = _derive_pkg_name(ctx)

    module_name = ctx.attr.module_name

    pkg_info = _get_pkg_info(pkgs_info.packages, pkg_name)
    module_info = _get_module_info(pkg_info, module_name)

    output = []
    file_type = ctx.attr.file_type
    if file_type == "o_files":
        output = module_info.o_files
    elif file_type == "c_files":
        output = module_info.c_files
    elif file_type == "swiftdoc":
        output = [module_info.swiftdoc]
    elif file_type == "swiftmodule":
        output = [module_info.swiftmodule]
    elif file_type == "swiftsourceinfo":
        output = [module_info.swiftsourceinfo]
    elif file_type == "hdrs":
        output = module_info.hdrs
    elif file_type == "modulemap":
        output = [module_info.modulemap]
    elif file_type == "all":
        output = module_info.all_files
    else:
        fail("Unrecognized file type: ", file_type)

    return [DefaultInfo(files = depset(output))]

spm_filegroup = rule(
    _spm_filegroup_impl,
    attrs = {
        "packages": attr.label(
            mandatory = True,
            providers = [[SPMPackagesInfo]],
            doc = """\
            A target that outputs an SPMPackagesInfo (e.g. spm_pacakge).\
            """,
        ),
        "package_name": attr.string(
            doc = """\
            The name of the package that exports this module. If no value 
            provided, it will be derived from the Bazel package name.\
            """,
        ),
        "module_name": attr.string(
            mandatory = True,
            doc = """\
            The name of the module in the SPM package to select for file exposition.\
            """,
        ),
        "file_type": attr.string(
            mandatory = True,
            values = [
                "o_files",
                "c_files",
                "swiftdoc",
                "swiftmodule",
                "swiftsourceinfo",
                "hdrs",
                "modulemap",
                "all",
            ],
            doc = """\
            The type of file to expose about the module.
            """,
        ),
    },
    doc = """\
    Exposes the specified type of file(s) from a rule that outputs an SPMPackagesInfo (e.g. 
    spm_package).
    """,
)
