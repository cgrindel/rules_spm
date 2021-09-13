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
    "//spm/internal:spm_swift_binary.bzl",
    _spm_swift_binary = "spm_swift_binary",
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
load(
    "//spm/internal:providers.bzl",
    _SPMBuildInfo = "SPMBuildInfo",
    _SPMPackageInfo = "SPMPackageInfo",
    _SPMPackagesInfo = "SPMPackagesInfo",
    _SPMPlatformInfo = "SPMPlatformInfo",
)
load(
    "//spm/internal:spm_common.bzl",
    _spm_common = "spm_common",
)
load(
    "//spm/internal:spm_package_info_utils.bzl",
    _spm_package_info_utils = "spm_package_info_utils",
)
load(
    "//spm/internal:spm_versions.bzl",
    _spm_versions = "spm_versions",
)
load(
    "//spm/internal:packages.bzl",
    _packages = "packages",
)

# load(
#     "//spm/internal:package_descriptions.bzl",
#     _package_descriptions = "package_descriptions",
# )
load(
    "//spm/internal:providers.bzl",
    _providers = "providers",
)
load(
    "//spm/internal:platforms.bzl",
    _platforms = "platforms",
)
load(
    "//spm/internal:references.bzl",
    _references = "references",
)

# load(
#     "//spm/internal:repositories.bzl",
#     _repositories = "repositories",
# )
load(
    "//spm/internal:repository_utils.bzl",
    _repository_utils = "repository_utils",
)

# Workspce Rules
spm_repositories = _spm_repositories
spm_pkg = _spm_pkg

# Build Rules and Macros
spm_package = _spm_package
spm_swift_binary = _spm_swift_binary
spm_swift_library = _spm_swift_library
spm_clang_library = _spm_clang_library
spm_system_library = _spm_system_library
spm_archive = _spm_archive

# Providers
SPMBuildInfo = _SPMBuildInfo
SPMPlatformInfo = _SPMPlatformInfo
SPMPackagesInfo = _SPMPackagesInfo
SPMPackageInfo = _SPMPackageInfo

# API
spm_common = _spm_common
spm_package_info_utils = _spm_package_info_utils
spm_versions = _spm_versions
packages = _packages

# package_descriptions = _package_descriptions
providers = _providers
platforms = _platforms
references = _references

# repositories = _repositories
repository_utils = _repository_utils
