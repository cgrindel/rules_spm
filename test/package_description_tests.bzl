load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load(
    "//spm/internal:package_description.bzl",
    "exported_targets",
    "is_library_product",
    "library_products",
    "parse_package_description_json",
)
load(":json_test_data.bzl", "package_description_json")

def _parse_package_description_json_test(ctx):
    env = unittest.begin(ctx)

    pkg_desc = parse_package_description_json(package_description_json)
    asserts.equals(env, 3, len(pkg_desc["targets"]))

    return unittest.end(env)

parse_package_description_json_test = unittest.make(_parse_package_description_json_test)

def _exported_targets_test(ctx):
    env = unittest.begin(ctx)

    pkg_desc = parse_package_description_json(package_description_json)
    result = exported_targets(pkg_desc)
    asserts.equals(env, 1, len(result))
    asserts.equals(env, "Logging", result[0]["c99name"])

    return unittest.end(env)

exported_targets_test = unittest.make(_exported_targets_test)

def _is_library_product_test(ctx):
    env = unittest.begin(ctx)

    product = {"type": {"library": {}}}
    asserts.true(env, is_library_product(product))
    product = {"type": {"executable": None}}
    asserts.false(env, is_library_product(product))

    return unittest.end(env)

is_library_product_test = unittest.make(_is_library_product_test)

def _library_products_test(ctx):
    env = unittest.begin(ctx)

    pkg_desc = {
        "products": [
            {"name": "Foo", "type": {"library": {}}},
            {"name": "Chicken", "type": {"executable": None}},
            {"name": "Bar", "type": {"library": {}}},
        ],
    }
    result = library_products(pkg_desc)
    asserts.equals(env, 2, len(result))
    product_names = [p["name"] for p in result]
    asserts.true(env, "Foo" in product_names)
    asserts.true(env, "Bar" in product_names)

    pkg_desc = {
        "products": [],
    }
    result = library_products(pkg_desc)
    asserts.equals(env, 0, len(result))

    return unittest.end(env)

library_products_test = unittest.make(_library_products_test)

def package_description_test_suite():
    unittest.suite(
        "package_description_tests",
        parse_package_description_json_test,
        exported_targets_test,
        is_library_product_test,
        library_products_test,
    )
