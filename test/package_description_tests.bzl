load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:package_description.bzl", "exported_targets", "parse_package_description_json")
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

def package_description_test_suite():
    unittest.suite(
        "package_description_tests",
        parse_package_description_json_test,
        exported_targets_test,
    )
