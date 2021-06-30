load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def spm_repository(name, urls, sha256, strip_prefix):
    http_archive(
        name = name,
        build_file = "@rules_swift_package_manager//swift_package_manager/internal:BUILD.spm_package.bzl",
        sha256 = sha256,
        strip_prefix = strip_prefix,
        urls = urls,
    )
