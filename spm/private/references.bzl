"""Definition for references module."""

def _create_ref(ref_type, pkg_name, name):
    """Creates a reference for the specified type.

    Args:
        ref_type: A `string` value. Must be one of the values in
                  `reference_types`.
        pkg_name: The package name as a `string`.
        name: The name of the item as a `string`.

    Returns:
        A `string` that references an entity in a set of package descriptions.
    """
    return "%s:%s/%s" % (ref_type, pkg_name, name)

def _split_ref(ref_str):
    """Splits a reference string into its parts.

    Args:
        ref_str: A valid reference `string`.

    Returns:
        A `tuple` where the first item is the reference type, the second is
        the package name, and the third is the item name.
    """
    type_value_parts = ref_str.split(":")
    if len(type_value_parts) != 2:
        fail("Expected a type and ref value. %s" % (ref_str))
    ref_type = type_value_parts[0]
    parts = type_value_parts[1].split("/")
    if len(parts) != 2:
        fail("Expected two parts from ref value. %s" % (ref_str))
    return (ref_type, parts[0], parts[1])

def _create_target_ref(pkg_name, by_name_values):
    """Create a target reference from dependency values found in dump-package JSON values.

    Example byName ref:
    `{ "byName": [ "Logging", null ] }`

    Args:
        pkg_name: The package name as a `string`.
        by_name_values: A `list` of `string` values where the first item is
                        the module name.

    Returns:
        A target reference `string` value.
    """
    if len(by_name_values) < 1:
        fail("Unexpected byName values were received. %s" % (by_name_values))
    target_name = by_name_values[0]
    return _create_ref(reference_types.target, pkg_name, target_name)

def _create_product_ref(product_values):
    """Create a product reference from dependency values found in dump-package JSON values.

    Example product ref:
    `{ "product": [ "NIO", "swift-nio", null ] }`

    Args:
        product_values: A `list` of `string` values where the first item is
                        the module name and the second is the package name.

    Returns:
        A product reference `string` value.
    """
    if len(product_values) < 2:
        fail("Unexpected product values were received. %s" % (product_values))
    pkg_name = product_values[1]
    product_name = product_values[0]
    return _create_ref(reference_types.product, pkg_name, product_name)

def _is_target_ref(ref_str, for_pkg = None):
    """Returns a boolean indicating whether the reference string is a target reference.

    Args:
       ref_str: A valid reference `string`.
       for_pkg: Optional. A package name as a `string` value to include in
                the check.

    Returns:
        A `bool` value indicating whether the reference string is a target
        reference.
    """
    starts_with_parts = [reference_types.target, ":"]
    if for_pkg != None:
        starts_with_parts.extend([for_pkg, "/"])
    return ref_str.startswith("".join(starts_with_parts))

def _is_product_ref(ref_str, for_pkg = None):
    """Returns a boolean indicating whether the reference string is a product reference.

    Args:
       ref_str: A valid reference `string`.
       for_pkg: Optional. A package name as a `string` value to include in
                the check.

    Returns:
        A `bool` value indicating whether the reference string is a product
        reference.
    """
    starts_with_parts = [reference_types.product, ":"]
    if for_pkg != None:
        starts_with_parts.extend([for_pkg, "/"])
    return ref_str.startswith("".join(starts_with_parts))

# MARK: - Namespace

reference_types = struct(
    target = "target",
    product = "product",
)

references = struct(
    create = _create_ref,
    split = _split_ref,
    create_target_ref = _create_target_ref,
    create_product_ref = _create_product_ref,
    is_target_ref = _is_target_ref,
    is_product_ref = _is_product_ref,
)
