load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_import",
)
load("//spm/internal:spm_filegroup.bzl", "spm_filegroup")

def spm_swift_module(name, package, deps = None):
    module_name = name

    swiftdoc_name = "%s_swiftdoc" % (name)
    spm_filegroup(
        name = swiftdoc_name,
        package = package,
        module_name = module_name,
        file_type = "swiftdoc",
    )

    swiftmodule_name = "%s_swiftmodule" % (name)
    spm_filegroup(
        name = swiftmodule_name,
        package = package,
        module_name = module_name,
        file_type = "swiftmodule",
    )

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
        deps = deps,
    )

    swift_import(
        name = name,
        archives = [":%s" % (objc_lib_name)],
        module_name = module_name,
        swiftdoc = ":%s" % (swiftdoc_name),
        swiftmodule = ":%s" % (swiftmodule_name),
        # deps = deps,
    )

    # # NOTE: Avoid import errors, but fails when trying to leverage stuff from imported modules.
    # native.objc_library(
    #     name = name,
    #     srcs = [
    #         ":%s" % (o_files_name),
    #     ],
    #     hdrs = [
    #         ":%s" % (hdrs_name),
    #     ],
    #     module_name = module_name,
    #     deps = deps,
    # )
