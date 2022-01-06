load("//spm/private:spm_autoconfiguration.bzl", "spm_autoconfiguration")
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
        name = "cgrindel_bazel_starlib",
        sha256 = "5b36e7f11bf0c1d52480f1b022430611b402b5424979f280f13c52550de76584",
        strip_prefix = "bazel-starlib-0.3.0",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.3.0.tar.gz",
        ],
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
