load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:sets.bzl", "sets")

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

    # DEBUG BEGIN
    print("*** CHUCK _get_package_description working_directory: ", working_directory)
    debug_result = repository_ctx.execute(
        ["tree"],
        working_directory = working_directory,
    )
    print("*** CHUCK debug_result.stdout:\n", debug_result.stdout)

    # DEBUG END
    describe_result = repository_ctx.execute(
        ["swift", "package", "describe", "--type", "json"],
        working_directory = working_directory,
    )
    return _parse_json(describe_result.stdout)

def _is_library_product(product):
    return "library" in product["type"]

def _library_products(pkg_desc):
    return [p for p in pkg_desc["products"] if _is_library_product(p)]

def _gather_deps_for_targets(targets_dict, target_names):
    deps = sets.make()
    for name in target_names:
        target = targets_dict[name]
        target_deps = target.get("target_dependencies", default = [])
        deps = sets.union(deps, sets.make(target_deps))
    return deps

def _exported_library_targets(pkg_desc, product_names = None, with_deps = False):
    """Returns the exported targets from the SPM pacakge.

    Args:
        pkg_desc: The dict returned from the `parse_package_descrition_json`.

    Returns:
        A list of the targets exported by the package.
    """
    targets_dict = dict([(p["name"], p) for p in pkg_desc["targets"]])
    products = _library_products(pkg_desc)
    if product_names != None:
        product_names_set = sets.make(product_names)
        products = [p for p in products if sets.contains(product_names_set, p["name"])]

    target_names = sets.make()

    # Collect the targets that are declared by the products.
    for product in products:
        for target_name in product["targets"]:
            sets.insert(target_names, target_name)

    # Collect the deps of the top-level targets
    if with_deps:
        target_names_to_collect = sets.to_list(target_names)
        for iteration in range(10):
            deps = _gather_deps_for_targets(targets_dict, target_names_to_collect)
            new_deps = sets.difference(deps, target_names)
            if sets.length(new_deps) == 0:
                break
            target_names_to_collect = sets.to_list(new_deps)
            target_names = sets.union(target_names, new_deps)

    return [targets_dict[target_name] for target_name in sets.to_list(target_names)]

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

def _dependency_repository_name(pkg_dep):
    url = pkg_dep["url"]
    basename = paths.basename(url)
    name, ext = paths.split_extension(basename)
    return name

def _dependency_name(pkg_dep):
    """Returns the name for the package dependency.

    Args:
        pkg_dep: An entry (`dict`) from a package description's dependencies list.

    Returns:
        The name as a `string`.
    """
    name = pkg_dep.get("name", default = "")
    if name != "":
        return name
    return _dependency_repository_name(pkg_dep)

def _is_clang_target(target):
    """Returns True if the specified target is a clang module. Otherwise, False.

    Args:
        target: A target from the package description.

    Returns:
        A boolean indicating whether the target is a clang module.
    """
    return target["module_type"] == module_types.clang

def _is_swift_target(target):
    """Returns True if the specified target is a swift module. Otherwise, False.

    Args:
        target: A target from the package description.

    Returns:
        A boolean indicating whether the target is a swift module.
    """
    return target["module_type"] == module_types.swift

def _get_target(pkg_desc, name):
    for t in pkg_desc["targets"]:
        if t["name"] == name:
            return t
    fail("Could not find target with name %s." % (name))

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
    is_clang_target = _is_clang_target,
    is_swift_target = _is_swift_target,
    get_target = _get_target,
    # Dependency Functions
    dependency_name = _dependency_name,
    dependency_repository_name = _dependency_repository_name,
    # Constants
    root_pkg_name = "_root",
)
