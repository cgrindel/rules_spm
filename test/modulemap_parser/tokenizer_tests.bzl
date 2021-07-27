load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _tokenize_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

tokenize_test = unittest.make(_tokenize_test)

def tokenizer_test_suite():
    return unittest.suite(
        "tokenizer_tests",
        tokenize_test,
    )
