"""Definition for spm_swift_binary rule."""

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

def _spm_swift_binary_impl(ctx):
    pkgs_info = ctx.attr.packages[SPMPackagesInfo]

    pkg_name = ctx.attr.package_name
    if pkg_name == "":
        pkg_name = _derive_pkg_name(ctx)

    module_name = ctx.attr.module_name
    if module_name == "":
        module_name = ctx.attr.name

    pkg_info = spm_package_info_utils.get(pkgs_info.packages, pkg_name)
    binary_info = spm_package_info_utils.get_module_info(pkg_info, module_name)

    if binary_info.executable == None:
        fail("The specified module (%s) is not executable." % (module_name))

    # Bazel will error if we try to return a file that we did not create as
    # the executable. So, we symlink it.
    executable = ctx.actions.declare_file(binary_info.executable.basename)
    ctx.actions.symlink(
        output = executable,
        target_file = binary_info.executable,
    )

    return [
        DefaultInfo(executable = executable),
    ]

spm_swift_binary = rule(
    implementation = _spm_swift_binary_impl,
    executable = True,
    attrs = {
        "module_name": attr.string(
            doc = """\
The name of the executable module in the SPM package. If no value
is provided, it will be derived from the name attribute.\
""",
        ),
        "package_name": attr.string(
            doc = """\
The name of the package that exports this module. If no value 
provided, it will be derived from the Bazel package name.\
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
    doc = "Exposes a Swift binary from a Swift package.",
)
