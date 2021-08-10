def _create_ref(ref_type, pkg_name, name):
    return "%s:%s/%s" % (ref_type, pkg_name, name)

def _split_ref(ref_str):
    type_value_parts = ref_str.split(":")
    if len(type_value_parts) != 2:
        fail("Expected a type and ref value. %s" % (ref_str))
    ref_type = type_value_parts[0]
    parts = type_value_parts[1].split("/")
    if len(parts) != 2:
        fail("Expected two parts from ref value. %s" % (ref_str))
    return (ref_type, parts[0], parts[1])

def _create_target_ref(pkg_name, by_name_values):
    #  {
    #    "byName": [
    #      "Logging",
    #      null
    #    ]
    #  }
    if len(by_name_values) < 1:
        fail("Unexpected byName values were received. %s" % (by_name_values))
    target_name = by_name_values[0]
    return _create_ref(reference_types.target, pkg_name, target_name)

def _create_product_ref(product_values):
    #  {
    #    "product": [
    #      "NIO",
    #      "swift-nio",
    #      null
    #    ]
    #  }
    if len(product_values) < 2:
        fail("Unexpected product values were received. %s" % (product_values))
    pkg_name = product_values[1]
    product_name = product_values[0]
    return _create_ref(reference_types.product, pkg_name, product_name)

def _is_target_ref(ref):
    return ref.startswith(reference_types.target + ":")

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
)
