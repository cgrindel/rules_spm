load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_spm_dependencies():
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
        name = "cgrindel_swift_toolbox",
        sha256 = "3b1022dcb99f45753f94d9e6c2623bf4973c887bae52df8bb1b25ee46878bdff",
        strip_prefix = "swift_toolbox-0.2.0",
        url = "https://github.com/cgrindel/swift_toolbox/archive/v0.2.0.tar.gz",
    )
