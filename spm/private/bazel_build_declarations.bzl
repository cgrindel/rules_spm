load(":build_declarations.bzl", "build_declarations")

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

def _swift_library(repository_ctx, pkg_name, target, target_deps):
    # TODO: IMPLEMENT ME!
    srcs_str = ""
    deps_str = ""
    target_name = target["name"]
    load_stmt = build_declarations.load_statement(
        "@build_bazel_rules_swift//swift:swift.bzl",
        "swift_library",
    )
    target_decl = build_declarations.target(
        type = "swift_library",
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
