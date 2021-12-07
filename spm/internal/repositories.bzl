load(":spm_autoconfiguration.bzl", "spm_autoconfiguration")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

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

    maybe(
        http_archive,
        name = "build_bazel_rules_swift",
        sha256 = "4f167e5dbb49b082c5b7f49ee688630d69fb96f15c84c448faa2e97a5780dbbc",
        url = "https://github.com/bazelbuild/rules_swift/releases/download/0.24.0/rules_swift.0.24.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "cgrindel_bazel_doc",
        sha256 = "3ccc6d205a7f834c5e89adcb4bc5091a9a07a69376107807eb9aea731ce92854",
        strip_prefix = "bazel-doc-0.1.2",
        urls = ["https://github.com/cgrindel/bazel-doc/archive/v0.1.2.tar.gz"],
    )

    maybe(
        http_archive,
        name = "cgrindel_rules_bzlformat",
        sha256 = "44b09ad9c5395760065820676ba6e65efec08ae02c1ce7e2d39d42c5b1e7aec8",
        strip_prefix = "rules_bzlformat-0.2.1",
        urls = ["https://github.com/cgrindel/rules_bzlformat/archive/v0.2.1.tar.gz"],
    )

    maybe(
        spm_autoconfiguration,
        name = "cgrindel_rules_spm_local_config",
    )

    maybe(
        http_archive,
        name = "cgrindel_rules_bazel_integration_test",
        sha256 = "50b808269ee09373c099256103c40629db8a66fd884030d7a36cf9a2e8675b75",
        strip_prefix = "rules_bazel_integration_test-0.3.1",
        urls = ["https://github.com/cgrindel/rules_bazel_integration_test/archive/v0.3.1.tar.gz"],
    )
