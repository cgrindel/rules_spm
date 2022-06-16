"""Module for defining SPM declarations."""

load(":build_declarations.bzl", "build_declarations")

_DEFS_BZL_LOCATION = "@cgrindel_rules_spm//spm:defs.bzl"
_SPM_CLANG_LIBRARY_TYPE = "spm_clang_library"
_SPM_SWIFT_BINARY_TYPE = "spm_swift_binary"
_SPM_SWIFT_LIBRARY_TYPE = "spm_swift_library"
_SPM_SYSTEM_LIBRARY_TYPE = "spm_system_library"

_spm_swift_binary_tpl = """
spm_swift_binary(
    name = "{exec_name}",
    packages = "@{repo_name}//:build",
    visibility = ["//visibility:public"],
)
"""

_spm_swift_library_tpl = """
spm_swift_library(
    name = "%s",
    packages = "@%s//:build",
    deps = [
%s
    ],
    visibility = ["//visibility:public"],
)
"""

_spm_clang_library_tpl = """
spm_clang_library(
    name = "%s",
    packages = "@%s//:build",
    deps = [
%s
    ],
    visibility = ["//visibility:public"],
)
"""

_spm_system_library_tpl = """
spm_system_library(
    name = "%s",
    packages = "@%s//:build",
    deps = [
%s
    ],
    visibility = ["//visibility:public"],
)
"""

def _spm_swift_binary(repository_ctx, product):
    """Returns the spm_swift_library declaration for this Swift target.

    Args:
        repository_ctx: A `repository_ctx` instance.
        product: A product `dict` from a package description JSON.

    Returns:
        A `string` representing an `spm_swift_binary` declaration.
    """
    return build_declarations.create(
        load_statements = [
            build_declarations.load_statement(
                _DEFS_BZL_LOCATION,
                _SPM_SWIFT_BINARY_TYPE,
            ),
        ],
        targets = [
            build_declarations.target(
                type = _SPM_SWIFT_BINARY_TYPE,
                name = product["name"],
                declaration = _spm_swift_binary_tpl.format(
                    repo_name = repository_ctx.attr.name,
                    exec_name = product["name"],
                ),
            ),
        ],
    )

def _spm_swift_library(repository_ctx, pkg_name, target, target_deps):
    """Returns the spm_swift_library declaration for this Swift target.

    Args:
        repository_ctx: A `repository_ctx` instance.
        pkg_name: The name of the Swift package as a `string`.
        target: A target `dict` from a package description JSON.
        target_deps: A `list` of the target's dependencies as target
                     references.

    Returns:
        A `string` representing an `spm_swift_library` declaration.
    """
    module_name = target["name"]
    deps_str = build_declarations.bazel_deps_str(
        pkg_name,
        target_deps,
    )

    return build_declarations.create(
        load_statements = [
            build_declarations.load_statement(
                _DEFS_BZL_LOCATION,
                _SPM_SWIFT_LIBRARY_TYPE,
            ),
        ],
        targets = [
            build_declarations.target(
                type = _SPM_SWIFT_LIBRARY_TYPE,
                name = module_name,
                declaration = _spm_swift_library_tpl % (
                    module_name,
                    repository_ctx.attr.name,
                    deps_str,
                ),
            ),
        ],
    )

def _spm_clang_library(repository_ctx, pkg_name, target, target_deps):
    """Returns the spm_clang_library declaration for this clang target.

    Args:
        repository_ctx: A `repository_ctx` instance.
        pkg_name: The name of the Swift package as a `string`.
        target: A target `dict` from a package description JSON.
        target_deps: A `list` of the target's dependencies as target
                     references.

    Returns:
        A `string` representing an `spm_clang_library` declaration.
    """
    module_name = target["name"]
    deps_str = build_declarations.bazel_deps_str(
        pkg_name,
        target_deps,
    )

    return build_declarations.create(
        load_statements = [
            build_declarations.load_statement(
                _DEFS_BZL_LOCATION,
                _SPM_CLANG_LIBRARY_TYPE,
            ),
        ],
        targets = [
            build_declarations.target(
                type = _SPM_CLANG_LIBRARY_TYPE,
                name = module_name,
                declaration = _spm_clang_library_tpl % (
                    module_name,
                    repository_ctx.attr.name,
                    deps_str,
                ),
            ),
        ],
    )

def _spm_system_library(repository_ctx, pkg_name, target, target_deps):
    """Returns the spm_clang_library declaration for this clang target.

    Args:
        repository_ctx: A `repository_ctx` instance.
        pkg_name: The name of the Swift package as a `string`.
        target: A target `dict` from a package description JSON.
        target_deps: A `list` of the target's dependencies as target
                     references.

    Returns:
        A `string` representing an `spm_clang_library` declaration.
    """
    module_name = target["name"]
    deps_str = build_declarations.bazel_deps_str(pkg_name, target_deps)

    return build_declarations.create(
        load_statements = [
            build_declarations.load_statement(
                _DEFS_BZL_LOCATION,
                _SPM_SYSTEM_LIBRARY_TYPE,
            ),
        ],
        targets = [
            build_declarations.target(
                type = _SPM_SYSTEM_LIBRARY_TYPE,
                name = module_name,
                declaration = _spm_system_library_tpl % (
                    module_name,
                    repository_ctx.attr.name,
                    deps_str,
                ),
            ),
        ],
    )

spm_build_declarations = struct(
    spm_swift_binary = _spm_swift_binary,
    spm_swift_library = _spm_swift_library,
    spm_clang_library = _spm_clang_library,
    spm_system_library = _spm_system_library,
)
