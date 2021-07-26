load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:tokenizer.bzl", "create_token")

def _create_token_test(ctx):
    env = unittest.begin(ctx)

    result = create_token(type = "foo", value = "bar")
    asserts.equals(env, result, struct(type = "foo", value = "bar"))

    return unittest.end(env)

create_token_test = unittest.make(_create_token_test)

def tokenizer_test_suite():
    return unittest.suite(
        "tokenizer_tests",
        create_token_test,
    )
