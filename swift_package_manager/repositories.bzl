load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
# load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def _maybe(repo_rule, name, **kwargs):
    """Executes the given repository rule if it hasn't been executed already.
    Args:
      repo_rule: The repository rule to be executed (e.g., `http_archive`.)
      name: The name of the repository to be defined by the rule.
      **kwargs: Additional arguments passed directly to the repository rule.
    """
    if not native.existing_rule(name):
        repo_rule(name = name, **kwargs)

def rules_swift_package_manager_dependencies():
    _maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
    )

    # _maybe(
    #     http_archive,
    #     name = "erickj_bazel_json",
    #     # name = "bazel_json",
    #     sha256 = "a57a6f794943548fde6da8ec3edad88af89436e8102f33d8f6135202699847f4",
    #     urls = ["https://github.com/erickj/bazel_json/archive/e954ef2c28cd92d97304810e8999e1141e2b5cc8.tar.gz"],  # 2019-01-02
    # )
    # _maybe(
    #     native.local_repository,
    #     name = "erickj_bazel_json",
    #     path = "../bazel_json",
    # )

    # Forked version with updates making it compatible with Bazel 4.1.0 and bazel-skylib 1.0.3.
    _maybe(
        http_archive,
        name = "erickj_bazel_json",
        sha256 = "50ee4730b124e143eab66afdbe2ce077858aba7c996ae9b1acb45927321d2cd3",
        strip_prefix = "bazel_json-916ead87b0c19ef6b8ff2763ff2a8e8a1072fa52",
        urls = ["https://github.com/cgrindel/bazel_json/archive/916ead87b0c19ef6b8ff2763ff2a8e8a1072fa52.tar.gz"],  # 2021-07-02
    )

    # maybe(
    #     http_archive,
    #     name = "build_bazel_rules_apple",
    #     sha256 = "c84962b64d9ae4472adfb01ec2cf1aa73cb2ee8308242add55fa7cc38602d882",
    #     urls = ["https://github.com/bazelbuild/rules_apple/releases/download/0.31.2/rules_apple.0.31.2.tar.gz"],
    # )
