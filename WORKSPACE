# TODO: Rename workspace to cgrindel_rules_spm.
workspace(name = "rules_swift_package_manager")

load("//swift_package_manager:repositories.bzl", "rules_swift_package_manager_dependencies")

rules_swift_package_manager_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

# load(
#     "@build_bazel_rules_apple//apple:repositories.bzl",
#     "apple_rules_dependencies",
# )

# apple_rules_dependencies()

# load(
#     "@build_bazel_rules_swift//swift:repositories.bzl",
#     "swift_rules_dependencies",
# )

# swift_rules_dependencies()

# load(
#     "@build_bazel_apple_support//lib:repositories.bzl",
#     "apple_support_dependencies",
# )

# apple_support_dependencies()

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:extras.bzl",
    "swift_rules_extra_dependencies",
)

swift_rules_extra_dependencies()
