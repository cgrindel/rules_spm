load("@bazel_skylib//lib:unittest.bzl", "unittest")

def _parse_json_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

parse_json_test = unittest.make(_parse_json_test)

def resolved_packages_test_suite():
    return unittest.suite(
        "resolved_packages_tests",
        parse_json_test,
    )
