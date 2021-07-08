load(
    "//spm/internal:spm_package.bzl",
    _spm_package = "spm_package",
)
load(
    "//spm/internal:spm_repository.bzl",
    _spm_repository = "spm_repository",
)
load(
    "//spm/internal:spm_swift_module.bzl",
    _spm_swift_module = "spm_swift_module",
)
load(
    "//spm/internal:spm_clang_module.bzl",
    _spm_clang_module = "spm_clang_module",
)

# Repository Rules
spm_repository = _spm_repository

# Regular Rules and Macros
spm_package = _spm_package
spm_swift_module = _spm_swift_module
spm_clang_module = _spm_clang_module
