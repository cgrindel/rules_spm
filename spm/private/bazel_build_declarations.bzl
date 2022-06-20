"""Module for defining build with Bazel declarations."""

load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:sets.bzl", "sets")
load(":build_declarations.bzl", "build_declarations")
load(":clang_files.bzl", "clang_files")

_DEFS_BZL_LOCATION = "@cgrindel_rules_spm//spm:defs.bzl"
_SWIFT_BZL_LOCATION = "@build_bazel_rules_swift//swift:swift.bzl"
_SWIFT_LIBRARY_TYPE = "swift_library"
_SWIFT_BINARY_TYPE = "swift_binary"
_BAZEL_CLANG_LIBRARY_TYPE = "bazel_clang_library"

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

_SWIFT_BINARY_TPL = """
swift_binary(
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

_BAZEL_CLANG_LIBRARY_TPL = """
bazel_clang_library(
    name = "{target_name}",
    hdrs = [
{hdrs}
    ],
    srcs = [
{srcs}
    ],
    includes = [
{includes}
    ],
    modulemap = {modulemap},
    deps = [
{deps}
    ],
    visibility = ["//visibility:public"],
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

def _swift_binary(pkg_name, product, target, target_deps):
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
    target_name = product["name"]
    load_stmt = build_declarations.load_statement(
        _SWIFT_BZL_LOCATION,
        _SWIFT_BINARY_TYPE,
    )
    target_decl = build_declarations.target(
        type = _SWIFT_BINARY_TYPE,
        name = target_name,
        declaration = _SWIFT_BINARY_TPL.format(
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

def _clang_library(repository_ctx, pkg_name, target, target_deps):
    """Generates a build declaration for clang libraries and system libraries.

    Args:
        repository_ctx: An instance of `repository_ctx`.
        pkg_name: The name of the package as a `string`.
        target: The target `dict`.
        target_deps: The dependencies for the target as a `list` of target
                     references.

    Returns:
        A build declaration `struct` as returned by `build_declarations.create`.
    """
    target_name = target["name"]

    # GH149: Check target for publicHeadersPath and sources to find the sources
    # and the headers.
    #  .target(
    #      name: "libwebp",
    #      dependencies: [],
    #      path: ".",
    #      sources: ["libwebp/src"],
    #      publicHeadersPath: "include",
    #      cSettings: [.headerSearchPath("libwebp")])
    target_manifest = target["manifest"]

    # We copy the source files to a directory that is named after the package.
    target_path = target["path"]
    src_path = paths.join(pkg_name, target_path) if target_path != "." else pkg_name

    collected_files = clang_files.collect_files(
        repository_ctx,
        src_path,
        remove_prefix = "{}/".format(pkg_name),
    )

    load_stmt = build_declarations.load_statement(
        _DEFS_BZL_LOCATION,
        _BAZEL_CLANG_LIBRARY_TYPE,
    )

    if collected_files.modulemap != None:
        modulemap_str = build_declarations.quote_str(collected_files.modulemap)
    else:
        modulemap_str = "None"

    public_hdrs_path = target_manifest.get("publicHeadersPath")
    includes = []
    if public_hdrs_path != None:
        includes.append(public_hdrs_path)
    private_hdr_dirs = sets.to_list(
        sets.make([
            paths.dirname(src)
            for src in collected_files.srcs
            if clang_files.is_hdr(src)
        ]),
    )
    includes.extend(private_hdr_dirs)

    # Be sure to add any parent directories to the includes list
    includes_set = sets.make(includes)
    for include in includes:
        parts = include.split("/")
        for idx, part in enumerate(parts):
            path = "/".join(parts[0:idx])
            if path != "":
                sets.insert(includes_set, path)
    includes = sets.to_list(includes_set)

    manifest_sources = target_manifest.get("sources", [])
    if manifest_sources != []:
        srcs = []
        for src in collected_files.srcs:
            for prefix in manifest_sources:
                if src.startswith(prefix):
                    srcs.append(src)
                    continue
    else:
        srcs = collected_files.srcs

    target_decl = build_declarations.target(
        type = _BAZEL_CLANG_LIBRARY_TYPE,
        name = target_name,
        declaration = _BAZEL_CLANG_LIBRARY_TPL.format(
            target_name = target_name,
            hdrs = build_declarations.bazel_list_str(collected_files.hdrs),
            srcs = build_declarations.bazel_list_str(srcs),
            includes = build_declarations.bazel_list_str(includes),
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
    swift_binary = _swift_binary,
    clang_library = _clang_library,
)
