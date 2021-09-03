load(":repository_utils.bzl", "repository_utils")

def _create_linux_toolchain(repository_ctx):
    path_to_swift = repository_ctx.which("swift")
    if not path_to_swift:
        fail("Could not find `swift` in $PATH.")

    # GH051: Do a better job figuring out what the target parameters should 
    # be.

    repository_ctx.file(
        "BUILD.bazel",
        """
load(
    "@cgrindel_rules_spm//spm/internal:spm_linux_toolchain.bzl",
    "spm_linux_toolchain",
)

package(default_visibility = ["//visibility:public"])

spm_linux_toolchain(
    name = "toolchain",
    arch = "x86_64",
    os = "linux",
    vendor = "unknown",
    abi = "gnu",
    swift_executable = "{swift}",
)
""".format(
            swift = path_to_swift,
        ),
    )

def _create_xcode_toolchain(repository_ctx):
    """Creates BUILD targets for the SPM toolchain on macOS using Xcode.

    Args:
      repository_ctx: The repository rule context.
    """

    # Not sure if there is a difference between using `which swift` vs
    # `xcrun --find swift`. Also, if one wants to use a custom toolchain/swift
    # this will need to be smarter.
    path_to_swift = repository_ctx.which("swift")
    if not path_to_swift:
        fail("Could not find `swift` in $PATH.")

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
    swift_executable = "{swift}",
)
""".format(
            swift = path_to_swift,
        ),
    )

def _spm_autoconfiguration_impl(repository_ctx):
    if repository_utils.is_macos(repository_ctx):
        _create_xcode_toolchain(repository_ctx)
    else:
        _create_linux_toolchain(repository_ctx)

spm_autoconfiguration = repository_rule(
    implementation = _spm_autoconfiguration_impl,
)
