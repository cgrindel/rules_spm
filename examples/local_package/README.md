# Local Package Example for `rules_spm`

This example demonstrates the use of a local Swift package. 

## Local Package with Absolute Path

To reference a local Swift package, one needs to specify the `path` and the `products` in the
`spm_pkg` declaration. The `path` value can be an absolute path or a relative path. The relative
path is resolved realtive to the root of the Bazel workspace.

```python
spm_repositories(
    name = "swift_pkgs",
    dependencies = [
        # Reference to a local package.
        spm_pkg(
            path = "/path/to/foo-kit",
            products = ["FooKit"],
        ),
    ],
)
```

## Shared Dependencies Example

This example, also, demonstrates that Swift package depdendencies which have their own external
dependencies work properly. In this case, the `cgrindel/rules_spm_example_pkg_with_deps` package has
a dependency on `apple/swift-nio` which is also a dependency of this example.

This case may sound mundane, but it exercises `rules_spm` functionality related to Bazel BUILD file
generation for all of the targets that will be built.
