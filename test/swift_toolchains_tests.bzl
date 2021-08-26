load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _sdk_name_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

sdk_name_test = unittest.make(_sdk_name_test)

def _os_name_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

os_name_test = unittest.make(_os_name_test)

def _target_triple_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

target_triple_test = unittest.make(_target_triple_test)

def swift_toolchains_test_suite():
    return unittest.suite(
        "swift_toolchains_tests",
        sdk_name_test,
        os_name_test,
        target_triple_test,
    )
