load(
    "//swift_package_manager/internal:spm_package.bzl",
    _spm_package = "spm_package",
)
load(
    "//swift_package_manager/internal:spm_repository_info.bzl",
    _spm_repository_info = "spm_repository_info",
)
load(
    "//swift_package_manager/internal:spm_repository.bzl",
    _spm_repository = "spm_repository",
)

spm_repository = _spm_repository
spm_repository_info = _spm_repository_info

spm_package = _spm_package
