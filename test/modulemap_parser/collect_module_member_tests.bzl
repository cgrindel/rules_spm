load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load(":test_helpers.bzl", "do_failing_parse_test", "do_parse_test")

def _parse_newline_in_module_member_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

parse_newline_in_module_member_test = unittest.make(_parse_newline_in_module_member_test)

def collect_module_member_test_suite():
    return unittest.suite(
        "collect_module_member_tests",
        parse_newline_in_module_member_test,
    )
