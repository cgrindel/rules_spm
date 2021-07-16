# load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
# load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

# def swift_test(name, srcs = None, size = "small", timeout = None, flaky = False, deps = [], data = [], env = {}, test_tags = []):
#     test_lib_name = "%sLib" % (name)

#     if srcs == None:
#         srcs = native.glob(["**/*.swift"])

#     swift_library(
#         name = test_lib_name,
#         testonly = 1,
#         srcs = srcs,
#         deps = deps,
#         visibility = ["//visibility:private"],
#     )

#     ios_unit_test(
#         name = name,
#         minimum_os_version = "14.0",
#         flaky = flaky,
#         env = env,
#         size = size,
#         timeout = timeout,
#         deps = [":%s" % (test_lib_name)],
#         resources = data,
#         tags = test_tags,
#         visibility = ["//visibility:private"],
#     )

load("@build_bazel_rules_swift//swift:swift.bzl", real_swift_test = "swift_test")

def swift_test(name, size = "small", deps = [], data = []):
    real_swift_test(
        name = name,
        size = size,
        srcs = native.glob(["**/*.swift"]),
        deps = deps,
        data = data,
    )
