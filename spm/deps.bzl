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
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
        ],
        sha256 = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728",
    )

    # Master as of 2022-06-16. Includes fix to 0.27.0 adding back missing bzl_library declarations.
    _RULES_SWIFT_VERSION = "a31c34e882dd68d15e8ed1007b1adc241857ab5a"
    maybe(
        http_archive,
        name = "build_bazel_rules_swift",
        sha256 = "8ddcc2207c3630bb19c5741151b6db5341c8f8eb5f844b773a50b5ee033306a8",
        strip_prefix = "rules_swift-{}".format(_RULES_SWIFT_VERSION),
        urls = [
            "http://github.com/bazelbuild/rules_swift/archive/{}.tar.gz".format(_RULES_SWIFT_VERSION),
        ],
    )

    maybe(
        http_archive,
        name = "cgrindel_bazel_starlib",
        sha256 = "c95de004f346cbcb51ba1185e8861227cd9ab248b53046f662aeda1095601bc9",
        strip_prefix = "bazel-starlib-0.7.1",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.7.1.tar.gz",
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
