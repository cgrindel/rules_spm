load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:tokens.bzl", "tokens")
load("//spm/internal/modulemap_parser:errors.bzl", "errors")

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
    asserts.equals(env, struct(type = tokens.types.newline, value = None), tokens.newline())
    asserts.equals(env, struct(type = tokens.types.square_bracket_open, value = None), tokens.square_bracket_open())
    asserts.equals(env, struct(type = tokens.types.square_bracket_close, value = None), tokens.square_bracket_close())
    asserts.equals(env, struct(type = tokens.types.exclamation_point, value = None), tokens.exclamation_point())
    asserts.equals(env, struct(type = tokens.types.comma, value = None), tokens.comma())
    asserts.equals(env, struct(type = tokens.types.period, value = None), tokens.period())

    return unittest.end(env)

create_token_test = unittest.make(_create_token_test)

def _get_test(ctx):
    env = unittest.begin(ctx)

    token_list = [tokens.comma()]

    token, err = tokens.get(token_list, 0)
    asserts.equals(env, None, err)
    asserts.equals(env, tokens.comma(), token)

    token, err = tokens.get(token_list, 1)
    asserts.equals(env, errors.new("No more tokens available. count: 1, idx: 1"), err)
    asserts.equals(env, None, token)

    token, err = tokens.get(token_list, -1)
    asserts.equals(env, errors.new("Negative indices are not supported. idx: -1"), err)
    asserts.equals(env, None, token)

    # Make sure that it uses the specified count.
    token, err = tokens.get(token_list, 0, count = 0)
    asserts.equals(env, errors.new("No more tokens available. count: 0, idx: 0"), err)
    asserts.equals(env, None, token)

    return unittest.end(env)

get_test = unittest.make(_get_test)

def _get_as_test(ctx):
    env = unittest.begin(ctx)

    token_list = [tokens.string_literal("Hello")]

    token, err = tokens.get_as(token_list, 0, tokens.types.string_literal)
    asserts.equals(env, None, err)
    asserts.equals(env, tokens.string_literal("Hello"), token)

    token, err = tokens.get_as(token_list, 0, tokens.types.string_literal, "Hello")
    asserts.equals(env, None, err)
    asserts.equals(env, tokens.string_literal("Hello"), token)

    token, err = tokens.get_as(token_list, 0, tokens.types.comma)
    asserts.equals(env, errors.new("Expected type comma, but was string_literal"), err)
    asserts.equals(env, None, token)

    token, err = tokens.get_as(token_list, 0, tokens.types.string_literal, "Goodbye")
    asserts.equals(env, errors.new("Expected value Goodbye, but was Hello"), err)
    asserts.equals(env, None, token)

    return unittest.end(env)

get_as_test = unittest.make(_get_as_test)

def tokens_test_suite():
    return unittest.suite(
        "tokens_tests",
        create_token_test,
        get_test,
        get_as_test,
    )
