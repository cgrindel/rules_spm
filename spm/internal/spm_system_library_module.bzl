load("//spm/internal:spm_filegroup.bzl", "spm_filegroup")

def spm_system_library_module(name, packages, deps = None, visibility = None):
    # TODO: Add doc
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

    native.objc_library(
        name = name,
        hdrs = [
            ":%s" % (hdr_files_name),
        ],
        srcs = [
            ":%s" % (src_files_name),
        ],
        # module_name = module_name,
        module_map = ":%s" % (modulemap_files_name),
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
