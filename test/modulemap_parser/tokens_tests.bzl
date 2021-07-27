load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:tokens.bzl", "token_types", "tokens")

def _create_token_test(ctx):
    env = unittest.begin(ctx)

    asserts.equals(env, struct(type = token_types.identifier, value = "bar"), tokens.create(token_types.identifier, "bar"))
    asserts.equals(env, struct(type = token_types.identifier, value = "bar"), tokens.create("identifier", "bar"))

    return unittest.end(env)

create_token_test = unittest.make(_create_token_test)

def tokens_test_suite():
    return unittest.suite(
        "tokens_tests",
        create_token_test,
    )
