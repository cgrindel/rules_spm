load(":providers.bzl", "SPMPackagesInfo")
load("@bazel_skylib//lib:paths.bzl", "paths")

def _derive_pkg_name(ctx):
    return paths.basename(paths.dirname(ctx.build_file_path))

def _get_pkg_info(pkg_infos, pkg_name):
    for pi in pkg_infos:
        if pi.name == pkg_name:
            return pi
    fail("Could not find package with name", pkg_name)

def _get_module_info(pkg_info, module_name):
    for module in pkg_info.swift_modules:
        if module.module_name == module_name:
            return module
    for module in pkg_info.clang_modules:
        if module.module_name == module_name:
            return module
    fail("Could not find module with name", module_name, "in package", pkg_info["name"])

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
    elif file_type == "swiftdoc":
        output = [module_info.swiftdoc]
    elif file_type == "swiftmodule":
        output = [module_info.swiftmodule]
    elif file_type == "swiftsourceinfo":
        output = [module_info.swiftsourceinfo]
    elif file_type == "hdrs":
        # DEBUG BEGIN
        print("*** CHUCK pkg_name: ", pkg_name)
        print("*** CHUCK module_name: ", module_name)
        print("*** CHUCK module_info.hdrs: ", module_info.hdrs)

        # DEBUG END
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
