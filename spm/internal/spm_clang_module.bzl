load("//spm/internal:spm_filegroup.bzl", "spm_filegroup")

def spm_clang_module(name, package, hdrs, deps = None):
    module_name = name

    o_files_name = "%s_o_files" % (name)
    spm_filegroup(
        name = o_files_name,
        package = package,
        module_name = module_name,
        file_type = "o_files",
    )

    native.objc_library(
        name = name,
        hdrs = hdrs,
        srcs = [
            ":%s" % (o_files_name),
        ],
        module_name = module_name,
        deps = deps,
    )
