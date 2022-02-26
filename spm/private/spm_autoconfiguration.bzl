"""Definition for spm_autoconfiguration rule."""

load(":repository_utils.bzl", "repository_utils")
load(":spm_versions.bzl", "spm_versions")

# MARK: - SPM Utilities

_SPM_UTILITIES_DIRNAME = "spm_utilities"
_XCODE_SPM_UTILITIES = ["git"]
_LINUX_SPM_UTILITIES = _XCODE_SPM_UTILITIES

def _prepare_spm_utilities(repository_ctx, utilities):
    # Create symlinks for all of the utilities that need to be available for
    # SPM.
    for spm_utility in utilities:
        util_path = repository_ctx.which(spm_utility)
        if not util_path:
            fail("Could not find `%s`." % (spm_utility))

        # NOTE: We could not use the skylib `paths` library, because it was not
        # loaded yet.
        repository_ctx.symlink(util_path, "{dir}/{util}".format(
            dir = _SPM_UTILITIES_DIRNAME,
            util = spm_utility,
        ))

    # Write BUILD.bazel file for the utilities.
    repository_ctx.file(
        _SPM_UTILITIES_DIRNAME + "/BUILD.bazel",
        """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_utilities",
    srcs = glob(["*"], exclude = ["BUILD.bazel"]),
)
""",
    )

# MARK: - Linux Toolchain

def _create_linux_toolchain(repository_ctx):
    _prepare_spm_utilities(repository_ctx, _LINUX_SPM_UTILITIES)

    swift_exec = repository_ctx.which("swift")
    spm_version = spm_versions.get(repository_ctx)

    # GH051: Do a better job figuring out what the target parameters should
    # be.
    arch = "x86_64"
    os = "linux"
    vendor = "unknown"
    abi = "gnu"

    repository_ctx.file(
        "BUILD.bazel",
        """
load(
    "@cgrindel_rules_spm//spm/private:spm_linux_toolchain.bzl",
    "spm_linux_toolchain",
)

package(default_visibility = ["//visibility:public"])

spm_linux_toolchain(
    name = "toolchain",
    arch = "{arch}",
    os = "{os}",
    vendor = "{vendor}",
    abi = "{abi}",
    swift_exec = "{swift_exec}",
    spm_version = "{spm_version}",
)
""".format(
            arch = arch,
            os = os,
            vendor = vendor,
            abi = abi,
            swift_exec = swift_exec,
            spm_version = spm_version,
        ),
    )

# MARK: - Xcode Toolchain

def _create_xcode_toolchain(repository_ctx):
    """Creates BUILD targets for the SPM toolchain on macOS using Xcode.

    Args:
      repository_ctx: The repository rule context.
    """
    _prepare_spm_utilities(repository_ctx, _XCODE_SPM_UTILITIES)
    repository_ctx.file(
        "BUILD.bazel",
        """
load(
    "@cgrindel_rules_spm//spm/private:spm_xcode_toolchain.bzl",
    "spm_xcode_toolchain",
)

package(default_visibility = ["//visibility:public"])

spm_xcode_toolchain(
    name = "toolchain",
)
""",
    )

def _spm_autoconfiguration_impl(repository_ctx):
    if repository_utils.is_macos(repository_ctx):
        _create_xcode_toolchain(repository_ctx)
    else:
        _create_linux_toolchain(repository_ctx)

spm_autoconfiguration = repository_rule(
    implementation = _spm_autoconfiguration_impl,
)
