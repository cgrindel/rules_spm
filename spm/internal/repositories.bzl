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
        sha256 = "b45b392613092b42c4ee94051be104b990e3c8651dea17410dfd63b98957cd57",
        strip_prefix = "rules_bzlformat-0.1.0",
        urls = ["https://github.com/cgrindel/rules_bzlformat/archive/v0.1.0.tar.gz"],
    )

    maybe(
        spm_autoconfiguration,
        name = "cgrindel_rules_spm_local_config",
    )

    maybe(
        http_archive,
        name = "build_bazel_integration_testing",
        url = "https://github.com/bazelbuild/bazel-integration-testing/archive/3a6136e8f6287b04043217d94d97ba17edcb7feb.zip",
        type = "zip",
        strip_prefix = "bazel-integration-testing-3a6136e8f6287b04043217d94d97ba17edcb7feb",
        sha256 = "bfc43a94d42e08c89a26a4711ea396a0a594bd5d55394d76aae861b299628dca",
    )

    maybe(
        http_archive,
        name = "cgrindel_bazel_starlib",
        sha256 = "1f5c6b13243a1a6f79742a8a0e883f7f4591f7890a388f87c8323f4242dc718d",
        strip_prefix = "bazel-starlib-0.1.0",
        urls = ["https://github.com/cgrindel/bazel-starlib/archive/v0.1.0.tar.gz"],
    )
