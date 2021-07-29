load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _parse_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

parse_test = unittest.make(_parse_test)

def collect_header_declaration_test_suite():
    return unittest.suite(
        "collect_header_declaration_tests",
        parse_test,
    )
