"""Definition for spm_filegroup rule."""

load("@bazel_skylib//lib:paths.bzl", "paths")
load(":providers.bzl", "SPMPackagesInfo")
load(":spm_package_info_utils.bzl", "spm_package_info_utils")

def _derive_pkg_name(ctx):
    """Determines the Swift package name from the Bazel package name.

    Args:
        ctx: A `ctx` instance.

    Returns:
        A `string` representing the Swift package name.
    """
    return paths.basename(paths.dirname(ctx.build_file_path))

def _spm_filegroup_impl(ctx):
    pkgs_info = ctx.attr.packages[SPMPackagesInfo]

    pkg_name = ctx.attr.package_name
    if pkg_name == "":
        pkg_name = _derive_pkg_name(ctx)

    module_name = ctx.attr.module_name
    pkg_info = spm_package_info_utils.get(pkgs_info.packages, pkg_name)
    module_info = spm_package_info_utils.get_module_info(pkg_info, module_name)

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
The type of file to expose about the module.\
""",
        ),
        "module_name": attr.string(
            mandatory = True,
            doc = """\
The name of the module in the SPM package to select for file exposition.\
""",
        ),
        "package_name": attr.string(
            doc = """\
The name of the package that exports this module. If no value provided, it \
will be derived from the Bazel package name.\
""",
        ),
        "packages": attr.label(
            mandatory = True,
            providers = [[SPMPackagesInfo]],
            doc = """\
A target that outputs an SPMPackagesInfo (e.g. spm_pacakge).\
""",
        ),
    },
    doc = """\
Exposes the specified type of file(s) from a rule that outputs an \
SPMPackagesInfo (e.g.  spm_package).\
""",
)
