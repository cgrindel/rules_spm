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
    "//spm/internal:spm_swift_library.bzl",
    _spm_swift_library = "spm_swift_library",
)
load(
    "//spm/internal:spm_clang_library.bzl",
    _spm_clang_library = "spm_clang_library",
)
load(
    "//spm/internal:spm_system_library.bzl",
    _spm_system_library = "spm_system_library",
)
load(
    "//spm/internal:spm_archive.bzl",
    _spm_archive = "spm_archive",
)

# Repository Rules
spm_repositories = _spm_repositories
spm_pkg = _spm_pkg

# Regular Rules and Macros
spm_package = _spm_package
spm_swift_library = _spm_swift_library
spm_clang_library = _spm_clang_library
spm_system_library = _spm_system_library
spm_archive = _spm_archive
