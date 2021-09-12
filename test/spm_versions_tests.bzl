load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _extract_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

extract_test = unittest.make(_extract_test)

def spm_versions_test_suite():
    return unittest.suite(
        "spm_versions_tests",
        extract_test,
    )
