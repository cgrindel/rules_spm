load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:parser.bzl", "parser")
load("//spm/internal/modulemap_parser:declarations.bzl", "declarations")

def do_parse_test(env, msg, text, expected):
    if not msg:
        unittest.fail("A message must be provided.")
    if not text:
        unittest.fail("A text value must be provided.")
    if not expected:
        unittest.fail("An expected value must be provied.")
    actual, err = parser.parse(text)
    asserts.false(env, err, msg)
    asserts.equals(env, expected, actual, msg)

def _parse_test(ctx):
    env = unittest.begin(ctx)

    # text = """
    # """
    # actual, err = parser.parse(text)
    # asserts.false(env, err, "parse empty string")
    # expected = parser.result()
    # asserts.equals(env, expected, actual, "parse empty string")
    do_parse_test(
        env,
        "parse empty string",
        text = """
        """,
        expected = parser.result(),
    )

    # text = """

    # """
    # actual, err = parser.parse(text)
    # asserts.false(env, err, "parse empty string")
    # expected = parser.result()
    # asserts.equals(env, expected, actual, "parse just newline")
    do_parse_test(
        env,
        "parse just newline",
        text = """

        """,
        expected = parser.result(),
    )

    # text = """
    # extern module MyModule "path/to/definition"
    # """
    # actual = parser.parse(text)
    # expected = parser.result([
    #     declarations.extern_module("MyModule", "path/to/definition"),
    # ])
    # asserts.equals(env, expected, actual, "parse extern module")

    return unittest.end(env)

parse_test = unittest.make(_parse_test)

def parser_test_suite():
    return unittest.suite(
        "parser_tests",
        parse_test,
    )
