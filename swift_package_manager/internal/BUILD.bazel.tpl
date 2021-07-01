# This is a template for generating an spm_repository BUILD.bazel file.

load("@rules_swift_package_manager//swift_package_manager:swift_package_manager.bzl", "spm_package")

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

spm_package(
    name = "build",
    srcs = [":all_srcs"],
    package_path = "external/{spm_repos_name}",
)
