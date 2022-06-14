"""Logic loading and organizing resolved Swift package information."""

def _create_state(revision, version, branch = None):
    return struct(
        revision = revision,
        version = version,
        branch = branch,
    )

def _create(name, url, state):
    return struct(
        name = name,
        url = url,
        state = state,
    )

def _parse_json(json_str):
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
            state = _create_state(
                revision = state_dict["revision"],
                version = state_dict["version"],
                branch = state_dict["branch"],
            ),
        )
    return result

def _read(repository_ctx, path = "Package.resolved"):
    json_str = repository_ctx.read("Package.resolved")
    return _parse_json(json_str)

# TODO: Add unit tests.

resolved_packages = struct(
    read = _read,
    parse_json = _parse_json,
)
