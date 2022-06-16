"""Definition for bazel_system_library rule."""

# load("@bazel_build_rules_cc//cc:defs.bzl", "cc_library")
load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_c_module",
)

# TODO: Rename if we do double duty.

def bazel_system_library(name, hdrs, srcs, includes, modulemap, deps = None, visibility = None):
    """Exposes a system library module as defined in a Swift package.

    Args:
        name: The Bazel target name.
        deps: Dependencies appropriate for the `swift_c_module` which defines
              the target.
        visibility: Target visibility.
    """
    module_name = name

    if modulemap != None:
        cc_lib_name = "%s_cc_lib" % (name)
        cc_lib_visibility = None
        swift_c_module(
            name = name,
            deps = [cc_lib_name],
            module_map = modulemap,
            module_name = module_name,
            visibility = visibility,
        )

    else:
        cc_lib_name = name
        cc_lib_visibility = visibility

    # cc_library(
    native.cc_library(
        name = cc_lib_name,
        hdrs = hdrs,
        srcs = srcs,
        includes = includes,
        tags = ["swift_module=%s" % (module_name)],
        deps = deps,
        visibility = cc_lib_visibility,
    )
