workspace(name = "cgrindel_rules_spm")

load("//spm:deps.bzl", "spm_rules_dependencies")

spm_rules_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

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

# MARK: - Documentation

load("@cgrindel_bazel_doc//bazeldoc:deps.bzl", "bazel_doc_dependencies")

bazel_doc_dependencies()

load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")

stardoc_repositories()
