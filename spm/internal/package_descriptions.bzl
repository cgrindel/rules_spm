load("@bazel_skylib//lib:paths.bzl", "paths")

def _parse_json(json_str):
    """Parses the JSON string and returns a dict representing the JSON structure.

    Args:
        json: JSON string.

    Returns:
        A dict which contains the information from the JSON string.
    """
    return json.decode(json_str)

# TODO: Consider converting the parsed json dict to a struct
# struct(**parsed_dict). Removes all of the string keys.

def _get_package_description(repository_ctx, working_directory = ""):
    """Returns a dict representing the package description for an SPM package.

    Args:
        repository_ctx: A `repository_ctx`.
        working_directory: A `string` specifying the directory for the SPM package.

    Returns:
        A `dict` representing an SPM package description.
    """
    describe_result = repository_ctx.execute(
        ["swift", "package", "describe", "--type", "json"],
        working_directory = working_directory,
    )
    return _parse_json(describe_result.stdout)

def _is_library_product(product):
    return "library" in product["type"]

def _library_products(pkg_desc):
    return [p for p in pkg_desc["products"] if _is_library_product(p)]

def _exported_library_targets(pkg_desc):
    """Returns the exported targets from the SPM pacakge.

    Args:
        pkg_desc: The dict returned from the `parse_package_descrition_json`.

    Returns:
        A list of the targets exported by the package.
    """
    targets_dict = dict([(p["name"], p) for p in pkg_desc["targets"]])
    products = _library_products(pkg_desc)

    target_names = []
    for product in products:
        for target_name in product["targets"]:
            if target_name not in target_names:
                target_names.append(target_name)

    return [targets_dict[target_name] for target_name in target_names]

def _is_library_target(target):
    """Returns True if the specified target is a library target. Otherwise False.

    Args:
        target: A target from the package description.

    Returns:
        A boolean indicating whether the target is a library target.
    """
    return target["type"] == "library"

def _library_targets(pkg_desc):
    """Returns a list of the library targets in the package.

    Args:
        pkg_desc: The dict returned from the `parse_package_descrition_json`.

    Returns:
        A list of the library targets in the package.
    """
    targets = pkg_desc["targets"]
    return [t for t in targets if _is_library_target(t)]

def _dependency_name(pkg_dep):
    """Returns the name for the package dependency.

    Args:
        pkg_dep: An entry (`dict`) from a package description's dependencies list.

    Returns:
        The name as a `string`.
    """
    url = pkg_dep["url"]
    basename = paths.basename(url)
    name, ext = paths.split_extension(basename)
    return name

def _is_clang_target(target):
    """Returns True if the specified target is a clang module. Otherwise, False.

    Args:
        target: A target from the package description.

    Returns:
        A boolean indicating whether the target is a clang module.
    """
    return target["module_type"] == module_types.clang

# MARK: - Namespace

module_types = struct(
    swift = "SwiftTarget",
    clang = "ClangTarget",
)

package_descriptions = struct(
    parse_json = _parse_json,
    get = _get_package_description,
    # Library Functions
    is_library_product = _is_library_product,
    library_products = _library_products,
    exported_library_targets = _exported_library_targets,
    # Target Functions
    is_library_target = _is_library_target,
    library_targets = _library_targets,
    dependency_name = _dependency_name,
    is_clang_target = _is_clang_target,
    # Constants
    root_pkg_name = "_root",
)
