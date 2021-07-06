load("@erickj_bazel_json//lib:json_parser.bzl", "json_parse")

def parse_package_descrition_json(json):
    """Parses the JSON string and returns a dict representing the JSON structure.

    Args:
        json: JSON string.

    Returns:
        A dict which contains the information from the JSON string.
    """
    return json_parse(json)

def exported_targets(pkg_desc):
    """Returns the exported targets from the SPM pacakge.

    Args:
        pkg_desc: The dict returned from the `parse_package_descrition_json`.

    Returns:
        A list of the targets exported by the package.
    """
    targets_dict = dict([(p["name"], p) for p in pkg_desc["targets"]])
    target_names = []
    for product in pkg_desc["products"]:
        for target_name in product["targets"]:
            if target_name not in target_names:
                target_names.append(target_name)

    return [targets_dict[target_name] for target_name in target_names]
