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

    # maybe(
    #     http_archive,
    #     name = "erickj_bazel_json",
    #     sha256 = "a57a6f794943548fde6da8ec3edad88af89436e8102f33d8f6135202699847f4",
    #     urls = ["https://github.com/erickj/bazel_json/archive/e954ef2c28cd92d97304810e8999e1141e2b5cc8.tar.gz"],  # 2019-01-02
    # )

    # Forked version with updates making it compatible with Bazel 4.1.0 and bazel-skylib 1.0.3.
    maybe(
        http_archive,
        name = "erickj_bazel_json",
        sha256 = "50ee4730b124e143eab66afdbe2ce077858aba7c996ae9b1acb45927321d2cd3",
        strip_prefix = "bazel_json-916ead87b0c19ef6b8ff2763ff2a8e8a1072fa52",
        urls = ["https://github.com/cgrindel/bazel_json/archive/916ead87b0c19ef6b8ff2763ff2a8e8a1072fa52.tar.gz"],  # 2021-07-02
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
        sha256 = "ebe0a3f1b91643fbf82f096a945bff7497acceb6607a0f1e10ec3ef2107c104c",
        strip_prefix = "swift_toolbox-0.1.0",
        url = "https://github.com/cgrindel/swift_toolbox/archive/v0.1.0.tar.gz",
    )
