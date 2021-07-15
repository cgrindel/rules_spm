load("@erickj_bazel_json//lib:json_parser.bzl", "json_parse")

def parse_package_description_json(json):
    """Parses the JSON string and returns a dict representing the JSON structure.

    Args:
        json: JSON string.

    Returns:
        A dict which contains the information from the JSON string.
    """
    return json_parse(json)

def is_library_product(product):
    return "library" in product["type"]

def library_products(pkg_desc):
    return [p for p in pkg_desc["products"] if is_library_product(p)]

def exported_library_targets(pkg_desc):
    """Returns the exported targets from the SPM pacakge.

    Args:
        pkg_desc: The dict returned from the `parse_package_descrition_json`.

    Returns:
        A list of the targets exported by the package.
    """
    targets_dict = dict([(p["name"], p) for p in pkg_desc["targets"]])
    products = library_products(pkg_desc)

    target_names = []
    for product in products:
        for target_name in product["targets"]:
            if target_name not in target_names:
                target_names.append(target_name)

    return [targets_dict[target_name] for target_name in target_names]

def is_library_target(target):
    """Returns True if the specified target is a library target. Otherwise False.

    Args:
        target: A target from the package description.

    Returns:
        A boolean indicating whether the target is a library target.
    """
    return target["type"] == "library"

def library_targets(pkg_desc):
    """Returns a list of the library targets in the package.

    Args:
        pkg_desc: The dict returned from the `parse_package_descrition_json`.

    Returns:
        A list of the library targets in the package.
    """
    targets = pkg_desc["targets"]
    return [t for t in targets if is_library_target(t)]
