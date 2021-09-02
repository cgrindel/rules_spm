load("//spm/internal:spm_filegroup.bzl", "spm_filegroup")
load(":package_descriptions.bzl", "module_types", pds = "package_descriptions")

def spm_clang_module(name, packages, deps = None, visibility = None):
    """Exposes a clang module as defined in a dependent Swift package.

    Args:
        name: The Bazel target name.
        packages: A target that outputs an SPMPackagesInfo provider (e.g.
                  `spm_package`).
        deps: Dependencies appropriate for the `objc_library` which defines
              the target.
        visibility: Target visibility.
    """
    module_name = name

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
        file_type = "o_files",
    )

    native.cc_library(
        name = name,
        hdrs = [
            ":%s" % (hdr_files_name),
        ],
        srcs = [
            ":%s" % (src_files_name),
        ],
        tags = [
            "swift_module=%s" % (module_name),
        ],
        deps = deps,
        visibility = visibility,
    )

    # native.objc_library(
    #     name = name,
    #     hdrs = [
    #         ":%s" % (hdr_files_name),
    #     ],
    #     srcs = [
    #         ":%s" % (src_files_name),
    #     ],
    #     module_name = module_name,
    #     deps = deps,
    #     visibility = visibility,
    # )
