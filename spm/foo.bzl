load(
    "//spm/internal:spm_repositories.bzl",
    _spm_pkg = "spm_pkg",
    _spm_repositories = "spm_repositories",
)
load(
    "//spm/internal:spm_package.bzl",
    _spm_package = "spm_package",
)
load(
    "//spm/internal:spm_swift_binary.bzl",
    _spm_swift_binary = "spm_swift_binary",
)
load(
    "//spm/internal:spm_swift_library.bzl",
    _spm_swift_library = "spm_swift_library",
)

# TODO: REMOVE ME

# Repository Rules
spm_repositories = _spm_repositories
spm_pkg = _spm_pkg

spm_package = _spm_package
spm_swift_binary = _spm_swift_binary
spm_swift_library = _spm_swift_library
