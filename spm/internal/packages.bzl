load("@bazel_skylib//lib:paths.bzl", "paths")

def _create_bzl_name(url):
    basename = paths.basename(url)
    repo_name, ext = paths.split_extension(basename)
    git_user = paths.basename(paths.dirname(url))
    raw_name = "%s_%s" % (git_user, repo_name)
    return raw_name.replace("-", "_")

def _create_spm_name(url):
    basename = paths.basename(url)
    repo_name, ext = paths.split_extension(basename)
    return repo_name

def _create_pkg(url, bzl_name = None, spm_name = None, from_version = None, products = []):
    """Create a Swift package dependency struct.

    Args:
        url: A `string` representing the URL for the package repository.
        products: A `list` of `string` values representing the names of the products to be used.
        bzl_name: Optional. The name (`string`) to be used for the package in Bazel.
        spm_name: Optional. The name (`string`) to be used for the package in Package.swift.
        from_version: A `string` representing a valid "from" SPM version.
                      https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html#package-dependency

    Returns:
        A `struct` representing a Swift package.
    """
    if bzl_name == None:
        bzl_name = _create_bzl_name(url)
    if spm_name == None:
        spm_name = _create_spm_name(url)
    if len(products) == 0:
        fail("A list of product names from the package must be provided.")

    return struct(
        url = url,
        bzl_name = bzl_name,
        spm_name = spm_name,
        from_version = from_version,
        products = products,
    )

def _to_json(url, bzl_name = None, spm_name = None, from_version = None, products = []):
    """Returns a JSON string describing a Swift package.

    Args:
        url: A `string` representing the URL for the package repository.
        products: A `list` of `string` values representing the names of the products to be used.
        bzl_name: Optional. The name (`string`) to be used for the package in Bazel.
        spm_name: Optional. The name (`string`) to be used for the package in Package.swift.
        from_version: A `string` representing a valid "from" SPM version.
                      https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html#package-dependency

    Returns:
        A JSON `string` representing a Swift package.
    """
    pkg = _create_pkg(url, bzl_name = bzl_name, spm_name = spm_name, from_version = from_version, products = products)
    return json.encode(pkg)

def _from_json(json_str):
    pkg_dict = json.decode(json_str)
    return _create_pkg(**pkg_dict)

packages = struct(
    create_spm_name = _create_spm_name,
    create_bzl_name = _create_bzl_name,
    create = _create_pkg,
    pkg_json = _to_json,
    from_json = _from_json,
)
