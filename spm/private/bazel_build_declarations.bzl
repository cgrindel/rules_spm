"""Module for defining build with Bazel declarations."""

load("@bazel_skylib//lib:paths.bzl", "paths")
load(":build_declarations.bzl", "build_declarations")

_SWIFT_BZL_LOCATION = "@build_bazel_rules_swift//swift:swift.bzl"
_SWIFT_LIBRARY_TYPE = "swift_library"

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

# GH149: Remove directive once implemented.
# buildifier: disable=unused-variable
def _swift_library(repository_ctx, pkg_name, target, target_deps):
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

bazel_build_declarations = struct(
    swift_library = _swift_library,
)
