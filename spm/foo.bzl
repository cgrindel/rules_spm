load(
    "//spm/internal:spm_repositories.bzl",
    _spm_pkg = "spm_pkg",
    _spm_repositories = "spm_repositories",
)

# Repository Rules
spm_repositories = _spm_repositories
spm_pkg = _spm_pkg
