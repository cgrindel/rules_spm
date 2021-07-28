load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:parser.bzl", "parser")
load("//spm/internal/modulemap_parser:declarations.bzl", "declarations")

def do_parse_test(env, msg, text, expected):
    if not msg:
        fail("A message must be provided.")
    if not text:
        fail("A text value must be provided.")
    if not expected:
        fail("An expected value must be provied.")

    actual, err = parser.parse(text)
    if err:
        unittest.fail(env, "%s: An error occurred. %s" % (msg, err))
        return
    asserts.equals(env, expected, actual, msg)

def _parse_test(ctx):
    env = unittest.begin(ctx)

    do_parse_test(
        env,
        "parse empty string",
        text = """
        """,
        expected = parser.result(),
    )

    do_parse_test(
        env,
        "parse just newline",
        text = """

        """,
        expected = parser.result(),
    )

    do_parse_test(
        env,
        "parse extern module",
        text = """
        extern module MyModule "path/to/definition"
        """,
        expected = parser.result([
            declarations.extern_module("MyModule", "path/to/definition"),
        ]),
    )

    return unittest.end(env)

parse_test = unittest.make(_parse_test)

def parser_test_suite():
    return unittest.suite(
        "parser_tests",
        parse_test,
    )
