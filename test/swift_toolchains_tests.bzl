load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _target_triple_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

target_triple_test = unittest.make(_target_triple_test)

def swift_toolchains_test_suite():
    return unittest.suite(
        "swift_toolchains_tests",
        target_triple_test,
    )
