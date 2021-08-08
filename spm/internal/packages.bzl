load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:types.bzl", "types")

def _create_name(url):
    basename = paths.basename(url)
    repo_name, ext = paths.split_extension(basename)
    return repo_name

def _create_pkg(url, name = None, from_version = None, products = []):
    """Create a Swift package dependency struct.

    Args:
        url: A `string` representing the URL for the package repository.
        products: A `list` of `string` values representing the names of the products to be used.
        name: Optional. The name (`string`) to be used for the package in Package.swift.
        from_version: A `string` representing a valid "from" SPM version.
                      https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html#package-dependency

    Returns:
        A `struct` representing a Swift package.
    """
    if name == None:
        name = _create_name(url)
    if len(products) == 0:
        fail("A list of product names from the package must be provided.")

    return struct(
        url = url,
        name = name,
        from_version = from_version,
        products = products,
    )

def _to_json(url, name = None, from_version = None, products = []):
    """Returns a JSON string describing a Swift package.

    Args:
        url: A `string` representing the URL for the package repository.
        products: A `list` of `string` values representing the names of the products to be used.
        name: Optional. The name (`string`) to be used for the package in Package.swift.
        from_version: A `string` representing a valid "from" SPM version.
                      https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html#package-dependency

    Returns:
        A JSON `string` representing a Swift package.
    """
    pkg = _create_pkg(url, name = name, from_version = from_version, products = products)
    return json.encode(pkg)

def _from_json(json_str):
    result = json.decode(json_str)
    if types.is_list(result):
        return [_create_pkg(**d) for d in result]
    elif types.is_dict(result):
        return _create_pkg(**result)
    fail("Unexpected result type decoding JSON string. %s" % (json_str))

def _get_pkg(pkgs, pkg_name):
    """Returns the package declaration from a list of package declarations.

    Args:
        pkgs: A `list` of package declarations (`struct`) as created by
              `packages.create()`, `packages.pkg_json()` or `spm_pkg()`.
        pkg_name: A `string` representing the name of the Swift package.

    Returns:
        A package declaration `struct` as created by
        `packages.create()`, `packages.pkg_json()` or `spm_pkg()`.
    """
    for pkg in pkgs:
        if pkg.name == pkg_name:
            return pkg
    fail("Failed to find package", pkg_name)

packages = struct(
    create_name = _create_name,
    create = _create_pkg,
    pkg_json = _to_json,
    from_json = _from_json,
    get_pkg = _get_pkg,
)
