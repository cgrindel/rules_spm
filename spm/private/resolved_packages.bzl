"""Logic loading and organizing resolved Swift package information."""

def _state(revision, version, branch = None):
    """Create a state `struct`

    Args:
        revision: A UUID `string`.
        version: A semver `string`.
        branch: Optional. A branch name as a `string`.

    Returns:
        A `struct` value.
    """
    return struct(
        revision = revision,
        version = version,
        branch = branch,
    )

def _create(name, url, state):
    """Create a resolved package `struct`.

    Args:
        name: The name of the package as a `string`.
        url: The URL for the package as a `string`.
        state: A state `struct` as created by 'resolved_packages.state'.

    Returns:
        A `struct` value.
    """
    return struct(
        name = name,
        url = url,
        state = state,
    )

def _parse_json(json_str):
    """Parse the JSON `string` returning a `dict` where the key is the name and \
the value is a resolved package `struct`.

    Args:
        json_str: A JSON `string` from a `Package.resolved` file.

    Returns:
        A `dict` where the key is the package name and the value is a resolved
        package `struct`.
    """

    # The resulting dict contains two keys: `object` and `version`.
    # The `object` is a dict that has a single key, `pins`. The `pins` value is
    # a `list` of resolved package entries.
    json_dict = json.decode(json_str)
    result = {}
    for pin_pkg_dict in json_dict["object"]["pins"]:
        name = pin_pkg_dict["package"]
        state_dict = pin_pkg_dict["state"]
        result[name] = _create(
            name = name,
            url = pin_pkg_dict["repositoryURL"],
            state = _state(
                revision = state_dict["revision"],
                version = state_dict["version"],
                branch = state_dict["branch"],
            ),
        )
    return result

def _read(repository_ctx, path = "Package.resolved"):
    """Read the specified `Package.resolved` file and return a `dict` of resolved package `struct` values.

    Args:
        repository_ctx: A `repository_ctx` instance.
        path: Optional. The path to the file as a `string`.

    Returns:
        A `dict` where the key is the package name and the value is a resolved
        package `struct`.
    """
    json_str = repository_ctx.read(path)
    return _parse_json(json_str)

resolved_packages = struct(
    state = _state,
    create = _create,
    read = _read,
    parse_json = _parse_json,
)
