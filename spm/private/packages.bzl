"""Package declaration logic."""

load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:types.bzl", "types")
load(":references.bzl", ref_types = "reference_types", refs = "references")

# MARK: - Package Creation Functions

def _create_name(url):
    """Create a package name (i.e. repository name) from the provided URL.

    Args:
        url: A URL `string`.

    Returns:
        A package name `string`.
    """
    basename = paths.basename(url)
    repo_name, _ext = paths.split_extension(basename)
    return repo_name

def _create_pkg(
        url = None,
        path = None,
        name = None,
        exact_version = None,
        from_version = None,
        revision = None,
        products = []):
    """Create a Swift package dependency struct.

    See the Swift Package Manager documentation for information on the various
    requirement specifications.

    https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html#package-dependency

    Args:
        url: A `string` representing the URL for the package repository.
        path: A local path `string` to the package repository.
        products: A `list` of `string` values representing the names of the products to be used.
        name: Optional. The name (`string`) to be used for the package in Package.swift.
        exact_version: Optional. A `string` representing a valid "exact" SPM version.
        from_version: Optional. A `string` representing a valid "from" SPM version.
        revision: Optional. A commit hash (`string`).

    Returns:
        A `struct` representing a Swift package.
    """
    specified_locations = [loc for loc in [url, path] if loc != None]
    specified_locations_cnt = len(specified_locations)
    if specified_locations_cnt < 1:
        fail("Need to specify a url or path to the package.")
    if specified_locations_cnt > 1:
        fail("Only a single location (e.g. url, path) can be specified.")

    if name == None:
        name = _create_name(specified_locations[0])
    if len(products) == 0:
        fail("A list of product names from the package must be provided.")

    if url != None:
        dep_requirements = [exact_version, from_version, revision]
        specified_dep_reqs = [d for d in dep_requirements if d != None]
        specified_dep_reqs_cnt = len(specified_dep_reqs)
        if specified_dep_reqs_cnt < 1:
            fail("A package requirement (e.g. exact_version, from_version, revision) must be specified.")
        if specified_dep_reqs_cnt > 1:
            fail("Only a single package requirement (e.g. exact_version, from_version, revision) can be specified.")

    return struct(
        url = url,
        path = path,
        name = name,
        exact_version = exact_version,
        from_version = from_version,
        revision = revision,
        products = products,
    )

def _copy_pkg(
        pkg,
        url = None,
        path = None,
        name = None,
        exact_version = None,
        from_version = None,
        revision = None,
        products = None):
    """Create a copy of the provided package replacing any of the argument values that are not None.

    Args:
        pkg: A `struct` representing a Swift package.
        url: Optional. A `string` representing the URL for the package repository.
        path: Optional. A local path `string` to the package repository.
        products: Optional. jA `list` of `string` values representing the names
                  of the products to be used.
        name: Optional. The name (`string`) to be used for the package in Package.swift.
        exact_version: Optional. A `string` representing a valid "exact" SPM version.
        from_version: Optional. A `string` representing a valid "from" SPM version.
        revision: Optional. A commit hash (`string`).

    Returns:
        A `struct` representing a Swift package.
    """
    return _create_pkg(
        url = url if url != None else pkg.url,
        path = path if path != None else pkg.path,
        name = name if name != None else pkg.name,
        exact_version = exact_version if exact_version != None else pkg.exact_version,
        from_version = from_version if from_version != None else pkg.from_version,
        revision = revision if revision != None else pkg.revision,
        products = products if products != None else pkg.products,
    )

# MARK: - Package JSON Functions

def _to_json(
        url = None,
        path = None,
        name = None,
        exact_version = None,
        from_version = None,
        revision = None,
        products = []):
    """Returns a JSON string describing a Swift package.

    See the Swift Package Manager documentation for information on the various
    requirement specifications.

    https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html#package-dependency

    Args:
        url: A `string` representing the URL for the package repository.
        path: A local path `string` to the package repository.
        products: A `list` of `string` values representing the names of the products to be used.
        name: Optional. The name (`string`) to be used for the package in Package.swift.
        exact_version: Optional. A `string` representing a valid "exact" SPM version.
        from_version: Optional. A `string` representing a valid "from" SPM version.
        revision: Optional. A commit hash (`string`).

    Returns:
        A JSON `string` representing a Swift package.
    """
    pkg = _create_pkg(
        url = url,
        path = path,
        name = name,
        exact_version = exact_version,
        from_version = from_version,
        revision = revision,
        products = products,
    )
    return json.encode(pkg)

def _from_json(json_str):
    """Creates a package struct(s) as described in the provided JSON string.

    Args:
        json_str: A JSON `string` that describes a package as declared in the
                  `dependencies` attribute for a `spm_repositories` rule.

    Returns:
        If the JSON represents a list of packages, a `list` of package `struct`
        values are returned. Otherwise, a single package `struct` value is
        returned. See `packages.create()` for more details on the struct.
    """
    result = json.decode(json_str)
    if types.is_list(result):
        return [_create_pkg(**d) for d in result]
    elif types.is_dict(result):
        return _create_pkg(**result)
    fail("Unexpected result type decoding JSON string. %s" % (json_str))

# MARK: - Package List Functions

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
    return None

def _get_product_refs(pkgs):
    """Returns a list of product references as declared in the specified packages list.

    Args:
        pkgs: A `list` of package declarations (`struct`) as created by
              `packages.create()`, `packages.pkg_json()` or `spm_pkg()`.

    Returns:
        A `list` of product reference (`string`) values.
    """
    return [refs.create(ref_types.product, pkg.name, prd) for pkg in pkgs for prd in pkg.products]

# MARK: - Namespace

packages = struct(
    create_name = _create_name,
    create = _create_pkg,
    copy = _copy_pkg,
    pkg_json = _to_json,
    from_json = _from_json,
    get_pkg = _get_pkg,
    get_product_refs = _get_product_refs,
)
