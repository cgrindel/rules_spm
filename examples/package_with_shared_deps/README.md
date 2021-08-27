# Package with Shared Dependencies Example for `rules_spm`

This example demonstrates that Swift package depdendencies which have their own external
dependencies work properly. In this case, the `cgrindel/rules_spm_example_pkg_with_deps` package has
a dependency on `apple/swift-nio` which is also a dependency of this example.

This case may sound mundane, but it exercises `rules_spm` functionality related to Bazel BUILD file
generation for all of the targets that will be built.
