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
        module_name = module_name,
        swiftdoc = ":%s" % (swiftdoc_name),
        swiftmodule = ":%s" % (swiftmodule_name),
        deps = deps,
    )
