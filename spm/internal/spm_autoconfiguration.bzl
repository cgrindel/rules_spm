load(":repository_utils.bzl", "repository_utils")

def _create_linux_toolchain(repository_ctx):
    fail("NOT IMPLEMENTED YET")

def _create_xcode_toolchain(repository_ctx):
    """Creates BUILD targets for the SPM toolchain on macOS using Xcode.

    Args:
      repository_ctx: The repository rule context.
    """
    repository_ctx.file(
        "BUILD.bazel",
        """
load(
    "@cgrindel_rules_spm//spm/internal:spm_xcode_toolchain.bzl",
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
