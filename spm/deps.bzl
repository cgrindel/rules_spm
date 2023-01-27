"""Dependencies for rules_spm."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//spm/private:spm_autoconfiguration.bzl", "spm_autoconfiguration")

def spm_rules_dependencies():
    """Loads the dependencies for `rules_spm`."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.0/bazel-skylib-1.4.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.0/bazel-skylib-1.4.0.tar.gz",
        ],
        sha256 = "f24ab666394232f834f74d19e2ff142b0af17466ea0c69a3f4c276ee75f6efce",
    )

    _RULES_SWIFT_VERSION = "1.1.1"
    maybe(
        http_archive,
        name = "build_bazel_rules_swift",
        sha256 = "043897b483781cfd6cbd521569bfee339c8fbb2ad0f0bdcd1b3749523a262cf4",
        urls = [
            "https://github.com/bazelbuild/rules_swift/releases/download/{version}/rules_swift.{version}.tar.gz".format(
                version = _RULES_SWIFT_VERSION,
            ),
        ],
    )

    maybe(
        http_archive,
        name = "cgrindel_bazel_starlib",
        sha256 = "3f04ca2e3bef99563c6d96728b0a09f8484bc3c61ca804d29f67e86e6043c038",
        strip_prefix = "bazel-starlib-0.11.0",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.11.0.tar.gz",
        ],
    )

    maybe(
        spm_autoconfiguration,
        name = "cgrindel_rules_spm_local_config",
    )

    # Master as of 2022-04-09
    _RULES_CC_VERSION = "58f8e026c00a8a20767e3dc669f46ba23bc93bdb"
    maybe(
        http_archive,
        # We purposefully do not name this rules_cc. An incompatibility appeared in Bazel 6.0 pre-release
        # where action_names.bzl was no longer available.
        name = "bazel_build_rules_cc",
        sha256 = "c22f7b4b87c0604f08479190fc0fb09c928982ff8f52b797263505e3b5a75f89",
        strip_prefix = "rules_cc-{}".format(_RULES_CC_VERSION),
        urls = [
            "http://github.com/bazelbuild/rules_cc/archive/{}.tar.gz".format(_RULES_CC_VERSION),
        ],
    )
