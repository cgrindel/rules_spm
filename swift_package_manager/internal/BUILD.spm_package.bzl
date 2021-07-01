# This is a part of the BUILD file that is generated for SPM repositories. Additional attributes
# are appended to the end.
load("@rules_swift_package_manager//swift_package_manager:swift_package_manager.bzl", "spm_package")

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

spm_package(
    name = "build",
    srcs = [":all_srcs"],
    package_path = "external/%s" % (SPM_REPOS_NAME),
)

# The following are parameters added to the end of this template during spm_repository macro
# expansion.
#
# SPM_REPOS_NAME = ""
