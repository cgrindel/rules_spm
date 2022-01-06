load(
    "//spm/private:spm_filegroup.bzl",
    _spm_filegroup = "spm_filegroup",
)
load(
    "//spm/private:spm_package.bzl",
    _spm_package = "spm_package",
)
load(
    "//spm/private:spm_repositories.bzl",
    _spm_pkg = "spm_pkg",
    _spm_repositories = "spm_repositories",
)
load(
    "//spm/private:spm_swift_library.bzl",
    _spm_swift_library = "spm_swift_library",
)
load(
    "//spm/private:spm_swift_binary.bzl",
    _spm_swift_binary = "spm_swift_binary",
)
load(
    "//spm/private:spm_clang_library.bzl",
    _spm_clang_library = "spm_clang_library",
)
load(
    "//spm/private:spm_system_library.bzl",
    _spm_system_library = "spm_system_library",
)
load(
    "//spm/private:spm_archive.bzl",
    _spm_archive = "spm_archive",
)
load(
    "//spm/private:providers.bzl",
    _SPMPackageInfo = "SPMPackageInfo",
    _SPMPackagesInfo = "SPMPackagesInfo",
    _SPMPlatformInfo = "SPMPlatformInfo",
    _SPMToolchainInfo = "SPMToolchainInfo",
)
load(
    "//spm/private:spm_common.bzl",
    _spm_common = "spm_common",
)
load(
    "//spm/private:spm_package_info_utils.bzl",
    _spm_package_info_utils = "spm_package_info_utils",
)
load(
    "//spm/private:spm_versions.bzl",
    _spm_versions = "spm_versions",
)
load(
    "//spm/private:packages.bzl",
    _packages = "packages",
)
load(
    "//spm/private:package_descriptions.bzl",
    _package_descriptions = "package_descriptions",
)
load(
    "//spm/private:providers.bzl",
    _providers = "providers",
)
load(
    "//spm/private:platforms.bzl",
    _platforms = "platforms",
)
load(
    "//spm/private:references.bzl",
    _references = "references",
)
load(
    "//spm/private:repositories.bzl",
    _spm_rules_dependencies = "spm_rules_dependencies",
)
load(
    "//spm/private:repository_utils.bzl",
    _repository_utils = "repository_utils",
)
load(
    "//spm/private:actions.bzl",
    _actions = "actions",
)

# Workspce Rules and Functions
spm_repositories = _spm_repositories
spm_pkg = _spm_pkg
spm_rules_dependencies = _spm_rules_dependencies

# Build Rules and Macros
spm_filegroup = _spm_filegroup
spm_package = _spm_package
spm_swift_binary = _spm_swift_binary
spm_swift_library = _spm_swift_library
spm_clang_library = _spm_clang_library
spm_system_library = _spm_system_library
spm_archive = _spm_archive

# Providers
SPMToolchainInfo = _SPMToolchainInfo
SPMPlatformInfo = _SPMPlatformInfo
SPMPackagesInfo = _SPMPackagesInfo
SPMPackageInfo = _SPMPackageInfo

# API
spm_common = _spm_common
spm_package_info_utils = _spm_package_info_utils
spm_versions = _spm_versions
packages = _packages
package_descriptions = _package_descriptions
providers = _providers
platforms = _platforms
references = _references
repository_utils = _repository_utils
actions = _actions
