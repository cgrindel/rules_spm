load(
    "//spm/internal:spm_package.bzl",
    _spm_package = "spm_package",
)
load(
    "//spm/internal:spm_repositories.bzl",
    _spm_pkg = "spm_pkg",
    _spm_repositories = "spm_repositories",
)
load(
    "//spm/internal:spm_swift_module.bzl",
    _spm_swift_module = "spm_swift_module",
)
load(
    "//spm/internal:spm_clang_module.bzl",
    _spm_clang_module = "spm_clang_module",
)
load(
    "//spm/internal:spm_system_library_module.bzl",
    _spm_system_library_module = "spm_system_library_module",
)

# Repository Rules
spm_repositories = _spm_repositories
spm_pkg = _spm_pkg

# Regular Rules and Macros
spm_package = _spm_package
spm_swift_module = _spm_swift_module
spm_clang_module = _spm_clang_module
spm_system_library_module = _spm_system_library_module
