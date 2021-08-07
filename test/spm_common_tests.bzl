load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _create_clang_hdrs_key_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

create_clang_hdrs_key_test = unittest.make(_create_clang_hdrs_key_test)

def _get_pkg_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

get_pkg_test = unittest.make(_get_pkg_test)

def spm_common_test_suite():
    return unittest.suite(
        "spm_common_tests",
        create_clang_hdrs_key_test,
        get_pkg_test,
    )
