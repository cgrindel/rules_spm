"""Definition for spm_swift_library rule."""

load("@build_bazel_rules_swift//swift:swift.bzl", "swift_import")
load(":spm_archive.bzl", "spm_archive")
load(":spm_filegroup.bzl", "spm_filegroup")

def spm_swift_library(name, packages, deps = None, visibility = None):
    """Exposes a Swift module as defined in a Swift package.

    Args:
        name: The Bazel target name.
        packages: A target that outputs an SPMPackagesInfo provider (e.g.
                  `spm_package`).
        deps: Dependencies appropriate for the `swift_import` which defines
              the target.
        visibility: Target visibility.
    """
    module_name = name

    swiftdoc_name = "%s_swiftdoc" % (name)
    spm_filegroup(
        name = swiftdoc_name,
        packages = packages,
        module_name = module_name,
        file_type = "swiftdoc",
    )

    swiftmodule_name = "%s_swiftmodule" % (name)
    spm_filegroup(
        name = swiftmodule_name,
        packages = packages,
        module_name = module_name,
        file_type = "swiftmodule",
    )

    o_files_name = "%s_o_files" % (name)
    spm_filegroup(
        name = o_files_name,
        packages = packages,
        module_name = module_name,
        file_type = "o_files",
    )

    a_file_name = "%s_a_file" % (name)
    spm_archive(
        name = a_file_name,
        o_files = ":%s" % o_files_name,
    )

    swift_import(
        name = name,
        archives = [":%s" % (a_file_name)],
        module_name = module_name,
        swiftdoc = ":%s" % (swiftdoc_name),
        swiftmodule = ":%s" % (swiftmodule_name),
        deps = deps,
        visibility = visibility,
    )
