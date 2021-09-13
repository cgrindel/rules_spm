load(":spm_autoconfiguration.bzl", "spm_autoconfiguration")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def spm_rules_dependencies():
    """Loads the dependencies for `rules_spm`."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "build_bazel_rules_swift",
        sha256 = "f872c0388808c3f8de67e0c6d39b0beac4a65d7e07eff3ced123d0b102046fb6",
        url = "https://github.com/bazelbuild/rules_swift/releases/download/0.23.0/rules_swift.0.23.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "io_bazel_stardoc",
        sha256 = "a9aa31f46fb674f8089530acc80d3214b3e6c32102cd8d42246fdac3eb77f52f",
        strip_prefix = "stardoc-03fc6d500fb2d6d21fa4fa241298356ab3950844",
        urls = ["https://github.com/bazelbuild/stardoc/archive/03fc6d500fb2d6d21fa4fa241298356ab3950844.tar.gz"],  # HEAD as of 2021-09-13
    )

    maybe(
        spm_autoconfiguration,
        name = "cgrindel_rules_spm_local_config",
    )
