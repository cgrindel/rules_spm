def _extract_version(version):
    """From a raw version string, extract the semantic version number.

    Input: `Swift Package Manager - Swift 5.4.0`
    Output: `5.4.0`

    Args:
        version: A `string` which has the semantic version embedded at the end.

    Returns:
        A `string` representing the semantic version.
    """

    # Need to parse the version number from `Swift Package Manager - Swift 5.4.0`
    for i in range(len(version)):
        c = version[i]
        if c.isdigit():
            return version[i:]

def _get_version(repository_ctx):
    """Returns the semantic version for Swit Package Manager.

    This is equivalent to running `swift package --version` and returning
    the semantic version.

    Args:
        repository_ctx: A `repository_ctx` instance.

    Returns:
        A `string` representing the semantic version for Swift Package Manager.
    """
    version_result = repository_ctx.execute(["swift", "package", "--version"])
    if version_result.return_code != 0:
        fail("Failed to retrieve the version for Swift Package Manager. %s" % (
            version_result.stderr
        ))
    return _extract_version(version_result.stdout)

spm_versions = struct(
    extract = _extract_version,
    get = _get_version,
)
