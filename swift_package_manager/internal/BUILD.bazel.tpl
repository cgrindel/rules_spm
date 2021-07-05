# This is a template for generating an spm_repository BUILD.bazel file.

load("@rules_swift_package_manager//swift_package_manager:swift_package_manager.bzl", "spm_package")

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

PACKAGE_DESCRIPTION_JSON = """
{pkg_desc_json}
"""

spm_package(
    name = "build",
    srcs = [":all_srcs"],
    package_description_json = PACKAGE_DESCRIPTION_JSON,
    package_path = "external/{spm_repos_name}",
)

filegroup(
    name = "o_files",
    srcs = [":build"],
    output_group = "o_files",
)

objc_library(
    name = "static_library",
    srcs = [
        ":o_files",
    ],
)
