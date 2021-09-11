# Local Package Example for `rules_spm`

This example demonstrates the use of a local Swift package. 

## Local Package with Absolute Path

To reference a local Swift package with an absolute path, one needs to specify the `path` and the
`products`.

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

## Local Package with Relative Path

To reference a local Swift package with a relative path, the package reference specifies the `path`
and the `products`. In addition, the `workspace_file` attribute must be provided on the
`spm_repositories` declaration.  Specifically, it must be `workspace_file = "//:WORKSPACE"`. This
allows the rule to find the `WORKSPACE` file which is used to evaluate the relative path in the
`spm_pkg` declaration.

```python
spm_repositories(
    name = "swift_pkgs",
    dependencies = [
        # Reference to a local package.
        spm_pkg(
            path = "third_party/foo-kit",
            products = ["FooKit"],
        ),
    ],
    # If using relative paths, one must provide the `workspace_file`.
    workspace_file = "//:WORKSPACE",
)
```

## Shared Dependencies Example

This example, also, demonstrates that Swift package depdendencies which have their own external
dependencies work properly. In this case, the `cgrindel/rules_spm_example_pkg_with_deps` package has
a dependency on `apple/swift-nio` which is also a dependency of this example.

This case may sound mundane, but it exercises `rules_spm` functionality related to Bazel BUILD file
generation for all of the targets that will be built.
