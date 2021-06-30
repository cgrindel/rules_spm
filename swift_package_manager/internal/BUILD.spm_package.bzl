load("@rules_swift_package_manager//swift_package_manager:swift_package_manager.bzl", "spm_package")

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

spm_package(
    name = "build",
    srcs = [":all_srcs"],
)
