load(
    "//swift_package_manager/internal:spm_package.bzl",
    _spm_package = "spm_package",
)
load(
    "//swift_package_manager/internal:spm_repository.bzl",
    _spm_repository = "spm_repository",
)
load(
    "//swift_package_manager/internal:spm_module.bzl",
    _spm_module = "spm_module",
)

# Repository Rules
spm_repository = _spm_repository

# Regular Rules and Macros
spm_package = _spm_package
spm_module = _spm_module
