"""Public API for rules_spm."""

load(
    "//spm/private:actions.bzl",
    _actions = "actions",
)
load(
    "//spm/private:bazel_build_declarations.bzl",
    _bazel_build_declarations = "bazel_build_declarations",
)
load(
    "//spm/private:bazel_clang_library.bzl",
    _bazel_clang_library = "bazel_clang_library",
)
load(
    "//spm/private:build_declarations.bzl",
    _build_declarations = "build_declarations",
)
load(
    "//spm/private:clang_files.bzl",
    _clang_files = "clang_files",
)
load(
    "//spm/private:package_descriptions.bzl",
    _module_types = "module_types",
    _package_descriptions = "package_descriptions",
)
load(
    "//spm/private:packages.bzl",
    _packages = "packages",
)
load(
    "//spm/private:platforms.bzl",
    _platforms = "platforms",
    _spm_oss = "spm_oss",
    _spm_vendors = "spm_vendors",
    _swift_archs = "swift_archs",
)
load(
    "//spm/private:providers.bzl",
    _SPMPackageInfo = "SPMPackageInfo",
    _SPMPackagesInfo = "SPMPackagesInfo",
    _SPMPlatformInfo = "SPMPlatformInfo",
    _SPMToolchainInfo = "SPMToolchainInfo",
    _providers = "providers",
)
load(
    "//spm/private:references.bzl",
    _reference_types = "reference_types",
    _references = "references",
)
load(
    "//spm/private:repository_files.bzl",
    _repository_files = "repository_files",
)
load(
    "//spm/private:repository_utils.bzl",
    _repository_utils = "repository_utils",
)
load(
    "//spm/private:resolved_packages.bzl",
    _resolved_packages = "resolved_packages",
)
load(
    "//spm/private:spm_archive.bzl",
    _spm_archive = "spm_archive",
)
load(
    "//spm/private:spm_build_declarations.bzl",
    _spm_build_declarations = "spm_build_declarations",
)
load(
    "//spm/private:spm_clang_library.bzl",
    _spm_clang_library = "spm_clang_library",
)
load(
    "//spm/private:spm_common.bzl",
    _spm_common = "spm_common",
)
load(
    "//spm/private:spm_filegroup.bzl",
    _spm_filegroup = "spm_filegroup",
)
load(
    "//spm/private:spm_package.bzl",
    _spm_package = "spm_package",
)
load(
    "//spm/private:spm_package_info_utils.bzl",
    _spm_package_info_utils = "spm_package_info_utils",
)
load(
    "//spm/private:spm_repositories.bzl",
    _spm_pkg = "spm_pkg",
    _spm_repositories = "spm_repositories",
)
load(
    "//spm/private:spm_swift_binary.bzl",
    _spm_swift_binary = "spm_swift_binary",
)
load(
    "//spm/private:spm_swift_library.bzl",
    _spm_swift_library = "spm_swift_library",
)
load(
    "//spm/private:spm_system_library.bzl",
    _spm_system_library = "spm_system_library",
)
load(
    "//spm/private:spm_versions.bzl",
    _spm_versions = "spm_versions",
)
load(
    "//spm/private:swift_toolchains.bzl",
    _swift_toolchains = "swift_toolchains",
)

# Workspce Rules and Functions
spm_pkg = _spm_pkg
spm_repositories = _spm_repositories

# Build Rules and Macros
bazel_clang_library = _bazel_clang_library
spm_archive = _spm_archive
spm_clang_library = _spm_clang_library
spm_filegroup = _spm_filegroup
spm_package = _spm_package
spm_swift_binary = _spm_swift_binary
spm_swift_library = _spm_swift_library
spm_system_library = _spm_system_library

# Providers
SPMPackageInfo = _SPMPackageInfo
SPMPackagesInfo = _SPMPackagesInfo
SPMPlatformInfo = _SPMPlatformInfo
SPMToolchainInfo = _SPMToolchainInfo

# API
actions = _actions
bazel_build_declarations = _bazel_build_declarations
build_declarations = _build_declarations
clang_files = _clang_files
module_types = _module_types
package_descriptions = _package_descriptions
packages = _packages
platforms = _platforms
providers = _providers
reference_types = _reference_types
references = _references
repository_utils = _repository_utils
repository_files = _repository_files
resolved_packages = _resolved_packages
spm_build_declarations = _spm_build_declarations
spm_common = _spm_common
spm_oss = _spm_oss
spm_package_info_utils = _spm_package_info_utils
spm_vendors = _spm_vendors
spm_versions = _spm_versions
swift_archs = _swift_archs
swift_toolchains = _swift_toolchains
