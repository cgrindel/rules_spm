load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:tokens.bzl", "create_token")

def _create_token_test(ctx):
    env = unittest.begin(ctx)

    asserts.equals(env, struct(type = "foo", value = "bar"), create_token("foo", "bar"))
    asserts.equals(env, struct(type = "foo", value = None), create_token("foo"))

    return unittest.end(env)

create_token_test = unittest.make(_create_token_test)

def tokens_test_suite():
    return unittest.suite(
        "tokens_tests",
        create_token_test,
    )
