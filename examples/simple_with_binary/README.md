# Simple Example for `rules_spm`

This example demonstrates how to use executables defined in third-party packages. Typically, these
binaries are used to maintain the project.

## Quick Start

Add an `spm_repositories` declaration for the external binaries.

```python
# These are packages that are dependencies for the project
spm_repositories(
    name = "swift_pkgs",
    dependencies = [
        spm_pkg(
            "https://github.com/apple/swift-log.git",
            exact_version = "1.4.2",
            products = ["Logging"],
        ),
    ],
)

# Thes are packages that have binaries that are useful to the project.
spm_repositories(
    name = "swift_utils",
    dependencies = [
        spm_pkg(
            "https://github.com/realm/SwiftLint.git",
            exact_version = "0.46.5",
            products = ["swiftlint"],
        ),
    ],
    platforms = [
        ".macOS(.v10_12)",
    ],
)

```

Add a reference to the binary that you want to use. In this case, we will create an alias in the
root of the project.

```python
# Make sure that the binary is referenced. Otherwise, Bazel won't build it.
alias(
    name = "swiftlint",
    actual = "@swift_utils//SwiftLint:swiftlint",
)
```

Use the binary. In this example, we will run `swiftlint` on the Swift files in the current
directory. NOTE: The `$(pwd)` magic is related to how Bazel executes binaries using `bazel run`.

```sh
$ bazel run //:swiftlint -- lint $(pwd)
INFO: Analyzed target //:swiftlint (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target @swift_utils//SwiftLint:swiftlint up-to-date:
  bazel-bin/external/swift_utils/SwiftLint/swiftlint
INFO: Elapsed time: 0.243s, Critical Path: 0.07s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Linting Swift files at paths /Users/chuck/code/cgrindel/rules_spm/examples/simple_with_binary
Linting 'main.swift' (1/1)
Done linting! Found 0 violations, 0 serious in 1 file.
```

## FAQ

### Can I add the binary packages to the same `spm_repositories` declaration as my dependencies?

Yes. However, you probably don't want to do so. The platform requirements for the binaries may be
more restrictive then those for your dependencies. In the above example, `swiftlint` requires that
the underlying SPM build require `.macOS(.v10_12)` or later. This may not be acceptable for your
final project.

