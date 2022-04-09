"""Definition for spm_system_library rule."""

load("@bazel_build_rules_cc//cc:defs.bzl", "cc_library")
load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_c_module",
)
load(":spm_filegroup.bzl", "spm_filegroup")

def spm_system_library(name, packages, deps = None, visibility = None):
    """Exposes a system library module as defined in a Swift package.

    Args:
        name: The Bazel target name.
        packages: A target that outputs an SPMPackagesInfo provider (e.g.
                  `spm_package`).
        deps: Dependencies appropriate for the `swift_c_module` which defines
              the target.
        visibility: Target visibility.
    """
    module_name = name

    modulemap_files_name = "%s_modulemap" % (name)
    spm_filegroup(
        name = modulemap_files_name,
        packages = packages,
        module_name = module_name,
        file_type = "modulemap",
    )

    hdr_files_name = "%s_hdrs" % (name)
    spm_filegroup(
        name = hdr_files_name,
        packages = packages,
        module_name = module_name,
        file_type = "hdrs",
    )

    src_files_name = "%s_src_files" % (name)
    spm_filegroup(
        name = src_files_name,
        packages = packages,
        module_name = module_name,
        file_type = "c_files",
    )

    cc_lib_name = "%s_cc_lib" % (name)
    cc_library(
        name = cc_lib_name,
        hdrs = [
            ":%s" % (hdr_files_name),
        ],
        srcs = [
            ":%s" % (src_files_name),
        ],
        tags = ["swift_module=%s" % (name)],
        deps = deps,
    )

    swift_c_module(
        name = name,
        deps = [
            ":%s" % (cc_lib_name),
        ],
        module_map = ":%s" % (modulemap_files_name),
        module_name = name,
        visibility = visibility,
    )
