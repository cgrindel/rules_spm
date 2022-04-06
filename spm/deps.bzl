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
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
        ],
        sha256 = "c6966ec828da198c5d9adbaa94c05e3a1c7f21bd012a0b29ba8ddbccb2c93b0d",
    )

    # TODO: Point to latest commit or release after https://github.com/bazelbuild/rules_swift/pull/793 is merged.

    # maybe(
    #     http_archive,
    #     name = "build_bazel_rules_swift",
    #     sha256 = "a2fd565e527f83fb3f9eb07eb9737240e668c9242d3bc318712efa54a7deda97",
    #     url = "https://github.com/bazelbuild/rules_swift/releases/download/0.27.0/rules_swift.0.27.0.tar.gz",
    # )

    maybe(
        native.local_repository,
        name = "build_bazel_rules_swift",
        path = "/Users/chuck/code/cgrindel/rules_swift/fix_missing_bzl_library",
    )

    maybe(
        http_archive,
        name = "cgrindel_bazel_starlib",
        sha256 = "8ac3e45dc237121283d70506497ec39feb5092af9a57bfe34f7abf4a6bd2ebaa",
        strip_prefix = "bazel-starlib-0.6.0",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.6.0.tar.gz",
        ],
    )

    maybe(
        spm_autoconfiguration,
        name = "cgrindel_rules_spm_local_config",
    )

    maybe(
        http_archive,
        name = "cgrindel_rules_bazel_integration_test",
        sha256 = "39071d2ec8e3be74c8c4a6c395247182b987cdb78d3a3955b39e343ece624982",
        strip_prefix = "rules_bazel_integration_test-0.5.0",
        urls = [
            "http://github.com/cgrindel/rules_bazel_integration_test/archive/v0.5.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "rules_cc",
        urls = ["https://github.com/bazelbuild/rules_cc/releases/download/0.0.1/rules_cc-0.0.1.tar.gz"],
        sha256 = "4dccbfd22c0def164c8f47458bd50e0c7148f3d92002cdb459c2a96a68498241",
    )
