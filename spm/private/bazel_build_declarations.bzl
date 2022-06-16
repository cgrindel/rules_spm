"""Module for defining build with Bazel declarations."""

load("@bazel_skylib//lib:paths.bzl", "paths")
load(":build_declarations.bzl", "build_declarations")
load(":clang_files.bzl", "clang_files")

_DEFS_BZL_LOCATION = "@cgrindel_rules_spm//spm:defs.bzl"
_SWIFT_BZL_LOCATION = "@build_bazel_rules_swift//swift:swift.bzl"
_SWIFT_LIBRARY_TYPE = "swift_library"
_BAZEL_SYSTEM_LIBRARY_TYPE = "bazel_system_library"

_SWIFT_LIBRARY_TPL = """
swift_library(
    name = "{target_name}",
    module_name = "{module_name}",
    srcs = [
{srcs}
    ],
    deps = [
{deps}
    ],
    visibility = ["//visibility:public"],
)
"""

_BAZEL_SYSTEM_LIBRARY_TPL = """
bazel_system_library(
    name = "{target_name}",
    hdrs = [
{hdrs}
    ],
    srcs = [
{srcs}
    ],
    modulemap = {modulemap},
    deps = [
{deps}
    ],
)
"""

def _swift_library(pkg_name, target, target_deps):
    target_path = target["path"]
    srcs = [
        paths.join(target_path, src)
        for src in target["sources"]
    ]
    srcs_str = build_declarations.bazel_list_str(
        srcs,
        double_quote_values = True,
    )
    deps_str = build_declarations.bazel_deps_str(pkg_name, target_deps)
    target_name = target["name"]
    load_stmt = build_declarations.load_statement(
        _SWIFT_BZL_LOCATION,
        _SWIFT_LIBRARY_TYPE,
    )
    target_decl = build_declarations.target(
        type = _SWIFT_LIBRARY_TYPE,
        name = target_name,
        declaration = _SWIFT_LIBRARY_TPL.format(
            target_name = target_name,
            module_name = target_name,
            srcs = srcs_str,
            deps = deps_str,
        ),
    )
    return build_declarations.create(
        load_statements = [load_stmt],
        targets = [target_decl],
    )

def _system_library(repository_ctx, pkg_name, target, target_deps):
    target_name = target["name"]

    collected_files = clang_files.collect_files(
        repository_ctx,
        paths.join(pkg_name, "Sources", target_name),
        remove_prefix = "{}/".format(pkg_name),
    )

    # DEBUG BEGIN
    print("*** CHUCK ======")
    print("*** CHUCK pkg_name: ", pkg_name)
    print("*** CHUCK target: ")
    for key in target:
        print("*** CHUCK", key, ":", target[key])

    print("*** CHUCK collected_files: ", collected_files)

    # DEBUG END
    load_stmt = build_declarations.load_statement(
        _DEFS_BZL_LOCATION,
        _BAZEL_SYSTEM_LIBRARY_TYPE,
    )

    if collected_files.modulemap != None:
        modulemap_str = build_declarations.quote_str(collected_files.modulemap)
    else:
        modulemap_str = "None"

    target_decl = build_declarations.target(
        type = _BAZEL_SYSTEM_LIBRARY_TYPE,
        name = target_name,
        declaration = _BAZEL_SYSTEM_LIBRARY_TPL.format(
            target_name = target_name,
            hdrs = build_declarations.bazel_list_str(collected_files.hdrs),
            srcs = build_declarations.bazel_list_str(collected_files.srcs),
            modulemap = modulemap_str,
            deps = build_declarations.bazel_deps_str(pkg_name, target_deps),
        ),
    )
    return build_declarations.create(
        load_statements = [load_stmt],
        targets = [target_decl],
    )

bazel_build_declarations = struct(
    swift_library = _swift_library,
    system_library = _system_library,
)
