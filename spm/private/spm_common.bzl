load("@bazel_skylib//lib:paths.bzl", "paths")

def _create_clang_hdrs_key(pkg_name, target_name):
    """Returns a key that is used for clang headers dictionaries.

    Args:
        pkg_name: A `string` that is the name of the Swift package.
        target_name: A `string` that is the name of the target.

    Returns:
        A `string` representing the combined items.
    """
    return "%s/%s" % (pkg_name, target_name)

def _split_clang_hdrs_key(key):
    """Returns the package name and the target name from a clang headers dictionary key.

    Args:
        key: A `string` representing a clange headers key.

    Returns:
        A two item `tuple` where the first item is the package name and
        the second item is the target name.
    """
    parts = key.split("/")
    if len(parts) != 2:
        fail("Unexpected clang headers key value. %s" % (key))
    return (parts[0], parts[1])

def _is_include_hdr_path(path):
    """Determines whether the path is a public header.

    Args:
        path: A path `string` value.

    Returns:
        A `bool` indicating whether the path is a public header.
    """
    root, ext = paths.split_extension(path)
    contains_include_dir = path.find("/include/") > -1
    return contains_include_dir and ext == ".h"

_build_dirname = "spm_build"
_checkouts_path = paths.join(_build_dirname, "checkouts")

spm_common = struct(
    create_clang_hdrs_key = _create_clang_hdrs_key,
    split_clang_hdrs_key = _split_clang_hdrs_key,
    is_include_hdr_path = _is_include_hdr_path,
    build_dirname = _build_dirname,
    checkouts_path = _checkouts_path,
)
