load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_import",
)
load("//spm/internal:spm_filegroup.bzl", "spm_filegroup")

def spm_swift_module(name, packages, deps = None, visibility = None):
    """Exposes a Swift module as defined in a dependent Swift package.

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

    objc_lib_name = "%s_static_library" % (name)
    native.objc_library(
        name = objc_lib_name,
        srcs = [
            ":%s" % (o_files_name),
        ],
        module_name = module_name,
    )

    swift_import(
        name = name,
        archives = [":%s" % (objc_lib_name)],
        module_name = module_name,
        swiftdoc = ":%s" % (swiftdoc_name),
        swiftmodule = ":%s" % (swiftmodule_name),
        deps = deps,
        visibility = visibility,
    )
