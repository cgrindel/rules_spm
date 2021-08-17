load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:references.bzl", ref_types = "reference_types", refs = "references")
load(
    "//spm/internal:package_descriptions.bzl",
    "module_types",
    pds = "package_descriptions",
)
load(":json_test_data.bzl", "package_description_json")

def _parse_json_test(ctx):
    env = unittest.begin(ctx)

    pkg_desc = pds.parse_json(package_description_json)
    asserts.equals(env, 3, len(pkg_desc["targets"]))

    return unittest.end(env)

parse_json_test = unittest.make(_parse_json_test)

def _is_library_product_test(ctx):
    env = unittest.begin(ctx)

    product = {"type": {"library": {}}}
    asserts.true(env, pds.is_library_product(product))
    product = {"type": {"executable": None}}
    asserts.false(env, pds.is_library_product(product))

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
    result = pds.library_products(pkg_desc)
    asserts.equals(env, 2, len(result))
    product_names = [p["name"] for p in result]
    asserts.true(env, "Foo" in product_names)
    asserts.true(env, "Bar" in product_names)

    pkg_desc = {
        "products": [],
    }
    result = pds.library_products(pkg_desc)
    asserts.equals(env, 0, len(result))

    return unittest.end(env)

library_products_test = unittest.make(_library_products_test)

def _is_library_target_test(ctx):
    env = unittest.begin(ctx)

    target = {"type": "library"}
    asserts.true(env, pds.is_library_target(target))
    target["type"] = "executable"
    asserts.false(env, pds.is_library_target(target))

    return unittest.end(env)

is_library_target_test = unittest.make(_is_library_target_test)

def _library_targets_test(ctx):
    env = unittest.begin(ctx)

    pkg_desc = {
        "targets": [
            {"name": "Foo", "type": "library"},
            {"name": "Chicken", "type": "executable"},
            {"name": "Bar", "type": "library"},
        ],
    }
    result = pds.library_targets(pkg_desc)
    asserts.equals(env, 2, len(result))
    target_names = [t["name"] for t in result]
    asserts.true(env, "Foo" in target_names)
    asserts.true(env, "Bar" in target_names)

    return unittest.end(env)

library_targets_test = unittest.make(_library_targets_test)

def _dependency_name_test(ctx):
    env = unittest.begin(ctx)

    pkg_dep = {"name": "foo-kit", "url": "https://github.com/swift-server/async-http-client.git"}
    asserts.equals(env, "foo-kit", pds.dependency_name(pkg_dep))

    pkg_dep = {"url": "https://github.com/swift-server/async-http-client.git"}
    asserts.equals(env, "async-http-client", pds.dependency_name(pkg_dep))

    return unittest.end(env)

dependency_name_test = unittest.make(_dependency_name_test)

def _dependency_repository_name_test(ctx):
    env = unittest.begin(ctx)

    pkg_dep = {"url": "https://github.com/swift-server/async-http-client.git"}
    asserts.equals(env, "async-http-client", pds.dependency_repository_name(pkg_dep))

    return unittest.end(env)

dependency_repository_name_test = unittest.make(_dependency_repository_name_test)

def _is_clang_target_test(ctx):
    env = unittest.begin(ctx)

    target = {"module_type": module_types.clang}
    asserts.true(env, pds.is_clang_target(target))

    target = {"module_type": module_types.system_library}
    asserts.true(env, pds.is_clang_target(target))

    target = {"module_type": module_types.swift}
    asserts.false(env, pds.is_clang_target(target))

    return unittest.end(env)

is_clang_target_test = unittest.make(_is_clang_target_test)

def _is_swift_target_test(ctx):
    env = unittest.begin(ctx)

    target = {"module_type": module_types.swift}
    asserts.true(env, pds.is_swift_target(target))

    target = {"module_type": module_types.clang}
    asserts.false(env, pds.is_swift_target(target))

    return unittest.end(env)

is_swift_target_test = unittest.make(_is_swift_target_test)

def _get_target_test(ctx):
    env = unittest.begin(ctx)

    pkg_desc = pds.parse_json(package_description_json)
    result = pds.get_target(pkg_desc, "Logging")
    asserts.equals(env, "Logging", result["name"])

    return unittest.end(env)

get_target_test = unittest.make(_get_target_test)

def _transitive_dependencies_test(ctx):
    env = unittest.begin(ctx)

    pkg_descs_dict = {
        "foo-kit": {
            "name": "foo-kit",
            "products": [
                {"name": "FooKit", "targets": ["FooKit"], "type": {"library": ["automatic"]}},
            ],
            "targets": [
                {
                    "name": "FooKit",
                    "dependencies": [
                        {"product": ["Logging", "swift-log", None]},
                        {"product": ["BarKit", "bar-kit", None]},
                        {"byName": ["CoolModule", None]},
                    ],
                    "module_type": "SwiftTarget",
                    "target_dependencies": ["CoolModule"],
                    "type": "library",
                },
                {
                    "name": "CoolModule",
                    "dependencies": [],
                    "module_type": "SwiftTarget",
                    "target_dependencies": [],
                    "type": "library",
                },
            ],
        },
        "bar-kit": {
            "name": "bar-kit",
            "products": [
                {"name": "BarKit", "targets": ["BarKit"], "type": {"library": ["automatic"]}},
            ],
            "targets": [
                {
                    "name": "BarKit",
                    "dependencies": [
                        {"product": ["Logging", "swift-log", None]},
                    ],
                    "module_type": "SwiftTarget",
                    "target_dependencies": [],
                    "type": "library",
                },
            ],
        },
        "swift-log": {
            "name": "swift-log",
            "products": [
                {"name": "Logging", "targets": ["Logging"], "type": {"library": ["automatic"]}},
            ],
            "targets": [
                {
                    "name": "Logging",
                    "dependencies": [],
                    "module_type": "SwiftTarget",
                    "target_dependencies": [],
                    "type": "library",
                },
            ],
        },
    }

    product_refs = ["product:swift-log/Logging"]
    actual = pds.transitive_dependencies(pkg_descs_dict, product_refs)
    expected = {
        "target:swift-log/Logging": [],
    }
    asserts.equals(env, expected, actual)

    product_refs = ["product:bar-kit/BarKit"]
    actual = pds.transitive_dependencies(pkg_descs_dict, product_refs)
    expected = {
        "target:swift-log/Logging": [],
        "target:bar-kit/BarKit": ["target:swift-log/Logging"],
    }
    asserts.equals(env, expected, actual)

    product_refs = ["product:foo-kit/FooKit"]
    actual = pds.transitive_dependencies(pkg_descs_dict, product_refs)
    expected = {
        "target:swift-log/Logging": [],
        "target:bar-kit/BarKit": ["target:swift-log/Logging"],
        "target:foo-kit/FooKit": [
            "target:bar-kit/BarKit",
            "target:foo-kit/CoolModule",
            "target:swift-log/Logging",
        ],
        "target:foo-kit/CoolModule": [],
    }
    asserts.equals(env, expected, actual)

    return unittest.end(env)

transitive_dependencies_test = unittest.make(_transitive_dependencies_test)

def package_descriptions_test_suite():
    unittest.suite(
        "package_description_tests",
        parse_json_test,
        is_library_product_test,
        library_products_test,
        is_library_target_test,
        library_targets_test,
        dependency_name_test,
        is_clang_target_test,
        is_swift_target_test,
        get_target_test,
        transitive_dependencies_test,
    )
