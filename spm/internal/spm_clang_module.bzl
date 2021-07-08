load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_import",
)
load("//spm/internal:spm_filegroup.bzl", "spm_filegroup")

def spm_clang_module(name, package):
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
        hdrs = [":%s" % (hdrs_name)],
        module_name = module_name,
    )
