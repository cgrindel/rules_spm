load("//spm/internal:spm_filegroup.bzl", "spm_filegroup")

def spm_clang_module(name, package, deps = None):
    module_name = name

    hdrs_name = "%s_hdrs" % (name)
    spm_filegroup(
        name = hdrs_name,
        package = package,
        module_name = module_name,
        file_type = "hdrs",
    )

    o_files_name = "%s_o_files" % (name)
    spm_filegroup(
        name = o_files_name,
        package = package,
        module_name = module_name,
        file_type = "o_files",
    )

    native.objc_library(
        name = name,
        hdrs = [":%s" % (hdrs_name)],
        srcs = [
            ":%s" % (o_files_name),
        ],
        module_name = module_name,
        deps = deps,
    )
