load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _create_name_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

create_name_test = unittest.make(_create_name_test)

def packages_test_suite():
    return unittest.suite(
        "packages_tests",
        create_name_test,
    )
