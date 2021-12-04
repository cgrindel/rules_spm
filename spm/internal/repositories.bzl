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
        sha256 = "bae4a0f41cc5cf89f26c779fc04379f09bb290b4910b2cf206c0372ad0c8aac7",
        strip_prefix = "bazel-doc-0.1.0",
        urls = ["https://github.com/cgrindel/bazel-doc/archive/v0.1.0.tar.gz"],
    )

    maybe(
        http_archive,
        name = "cgrindel_rules_bzlformat",
        sha256 = "df22d867e661de66a255a994caf814ff66426a43873194575bcaaaf9b9ad89ed",
        strip_prefix = "rules_bzlformat-0.2.0",
        urls = ["https://github.com/cgrindel/rules_bzlformat/archive/v0.2.0.tar.gz"],
    )

    maybe(
        spm_autoconfiguration,
        name = "cgrindel_rules_spm_local_config",
    )

    maybe(
        http_archive,
        name = "cgrindel_rules_bazel_integration_test",
        sha256 = "ef6cf463a269d969bdb3b31eed53c50d3667f02e004abc9ce7a3a2413eadca6a",
        strip_prefix = "rules_bazel_integration_test-0.3.0",
        urls = ["https://github.com/cgrindel/rules_bazel_integration_test/archive/v0.3.0.tar.gz"],
    )
