load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _create_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

create_test = unittest.make(_create_test)

def errors_test_suite():
    return unittest.suite(
        "errors_tests",
        create_test,
    )
