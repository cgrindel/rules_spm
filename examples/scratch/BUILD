load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load(
    "@com_github_buildbuddy_io_rules_xcodeproj//xcodeproj:xcodeproj.bzl",
    "xcodeproj",
)

swift_library(
    name = "Lib",
    srcs = glob(["**/*.swift"]),
    deps = ["@swift_pkgs//swift-nio:_NIODataStructures"],
)

ios_application(
    name = "App",
    bundle_id = "com.example.app",
    families = [
        "iphone",
        "ipad",
    ],
    infoplists = [":Info.plist"],
    minimum_os_version = "15.0",
    deps = [":Lib"],
)

xcodeproj(
    name = "xcodeproj",
    project_name = "App",
    tags = ["manual"],
    targets = [
        ":App",
    ],
)
