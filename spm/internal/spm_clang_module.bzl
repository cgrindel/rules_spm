load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_import",
)
load("//spm/internal:spm_filegroup.bzl", "spm_filegroup")
# load("@rules_pkg//:pkg.bzl", "pkg_tar")

def spm_clang_module(name, package):
    module_name = name

    hdrs_name = "%s_hdrs" % (name)
    spm_filegroup(
        name = hdrs_name,
        package = package,
        module_name = module_name,
        file_type = "hdrs",
    )

    modulemap_name = "%s_modulemap" % (name)
    spm_filegroup(
        name = modulemap_name,
        package = package,
        module_name = module_name,
        file_type = "modulemap",
    )

    o_files_name = "%s_o_files" % (name)
    spm_filegroup(
        name = o_files_name,
        package = package,
        module_name = module_name,
        file_type = "o_files",
    )

    # tar_name = "%s_tar" % (name)
    # pkg_tar(
    #     name = tar_name,
    #     extension = "tar.gz",
    #     srcs = [
    #         ":%s" % (modulemap_name),
    #     ],
    # )

    # objc_lib_name = "%s_static_library" % (name)
    native.objc_library(
        # name = objc_lib_name,
        name = name,
        hdrs = [":%s" % (hdrs_name)],
        srcs = [
            ":%s" % (o_files_name),
        ],
        # module_map = ":%s" % (modulemap_name),
        module_name = module_name,
    )

    # TODO: Should I be creating a swift_c_module that is then imported?

#     swift_import(
#         name = name,
#         archives = [":%s" % (objc_lib_name)],
#         module_name = module_name,
#     )
