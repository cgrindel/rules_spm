load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_SPM_PACKAGE_BUILD_FILE = """
filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)
"""

def spm_repository(name, urls, sha256, strip_prefix):
    http_archive(
        name = "%s_archive" % (name),
        build_file_content = _SPM_PACKAGE_BUILD_FILE,
        sha256 = sha256,
        strip_prefix = strip_prefix,
        urls = urls,
    )
