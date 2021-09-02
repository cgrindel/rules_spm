load( "@build_bazel_rules_swift//swift:swift.bzl", "swift_import")
load(":spm_filegroup.bzl", "spm_filegroup")
load(":spm_archive.bzl", "spm_archive")

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
    
    # TODO: Create a rule that converts the .o files to .a.
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


    # shared_object_name = "%s_shared_object" % (name)
    # native.cc_library(
    #     name = shared_object_name,
    #     srcs = [
    #         ":%s" % (o_files_name),
    #     ],
    #     # tags = [
    #     #     "swift_module=%s" % (module_name),
    #     # ],
    # )



    # objc_lib_name = "%s_static_library" % (name)
    # native.objc_library(
    #     name = objc_lib_name,
    #     srcs = [
    #         ":%s" % (o_files_name),
    #     ],
    #     module_name = module_name,
    # )

    # objc_lib_name = "%s_static_library" % (name)
    # native.cc_library(
    #     name = objc_lib_name,
    #     srcs = [
    #         ":%s" % (o_files_name),
    #     ],
    #     # tags = [
    #     #     "swift_module=%s" % (module_name),
    #     # ],
    # )

    # swift_import(
    #     name = name,
    #     archives = [":%s" % (objc_lib_name)],
    #     module_name = module_name,
    #     swiftdoc = ":%s" % (swiftdoc_name),
    #     swiftmodule = ":%s" % (swiftmodule_name),
    #     deps = deps,
    #     visibility = visibility,
    # )



    # swift_import(
    #     name = name,
    #     archives = [":%s" % (objc_lib_name)],
    #     module_name = module_name,
    #     swiftdoc = ":%s" % (swiftdoc_name),
    #     swiftmodule = ":%s" % (swiftmodule_name),
    #     deps = deps,
    #     visibility = visibility,
    # )

    # # DOES NOT WORK
    # swift_import(
    #     name = name,
    #     archives = [":%s" % (o_files_name)],
    #     module_name = module_name,
    #     swiftdoc = ":%s" % (swiftdoc_name),
    #     swiftmodule = ":%s" % (swiftmodule_name),
    #     deps = deps,
    #     visibility = visibility,
    # )
