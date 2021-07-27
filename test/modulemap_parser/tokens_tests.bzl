load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:tokens.bzl", "tokens")

def _create_token_test(ctx):
    env = unittest.begin(ctx)

    asserts.equals(env, struct(type = tokens.types.identifier, value = "bar"), tokens.identifier("bar"))
    asserts.equals(env, struct(type = tokens.types.comma, value = None), tokens.comma())

    asserts.equals(env, struct(type = tokens.types.reserved, value = "module"), tokens.reserved("module"))
    asserts.equals(env, struct(type = tokens.types.identifier, value = "a1234"), tokens.identifier("a1234"))
    asserts.equals(env, struct(type = tokens.types.string_literal, value = "Hello, World!"), tokens.string_literal("Hello, World!"))
    asserts.equals(env, struct(type = tokens.types.integer_literal, value = 123), tokens.integer_literal(123))
    asserts.equals(env, struct(type = tokens.types.float_literal, value = 123.45), tokens.float_literal(123.45))
    asserts.equals(env, struct(type = tokens.types.comment, value = "A helpful comment."), tokens.comment("A helpful comment."))
    asserts.equals(env, struct(type = tokens.types.operator, value = "*"), tokens.operator("*"))
    asserts.equals(env, struct(type = tokens.types.curly_bracket_open, value = None), tokens.curly_bracket_open())
    asserts.equals(env, struct(type = tokens.types.curly_bracket_close, value = None), tokens.curly_bracket_close())
    asserts.equals(env, struct(type = tokens.types.newLine, value = None), tokens.newLine())
    asserts.equals(env, struct(type = tokens.types.square_bracket_open, value = None), tokens.square_bracket_open())
    asserts.equals(env, struct(type = tokens.types.square_bracket_close, value = None), tokens.square_bracket_close())
    asserts.equals(env, struct(type = tokens.types.exclamation_point, value = None), tokens.exclamation_point())
    asserts.equals(env, struct(type = tokens.types.comma, value = None), tokens.comma())
    asserts.equals(env, struct(type = tokens.types.period, value = None), tokens.period())

    return unittest.end(env)

create_token_test = unittest.make(_create_token_test)

def tokens_test_suite():
    return unittest.suite(
        "tokens_tests",
        create_token_test,
    )
