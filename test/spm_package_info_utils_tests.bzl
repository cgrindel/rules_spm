load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _get_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

get_test = unittest.make(_get_test)

def _get_module_info_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

get_module_info_test = unittest.make(_get_module_info_test)

def spm_package_info_utils_test_suite():
    return unittest.suite(
        "spm_package_info_utils_tests",
        get_test,
        get_module_info_test,
    )
