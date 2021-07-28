load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:parser.bzl", "parser")
load("//spm/internal/modulemap_parser:declarations.bzl", "declarations")

def _parse_test(ctx):
    env = unittest.begin(ctx)

    text = """
    """
    actual = parser.parse(text)
    expected = parser.result()
    asserts.equals(env, expected, actual, "parse empty string")

    text = """

    """
    actual = parser.parse(text)
    expected = parser.result()
    asserts.equals(env, expected, actual, "parse just newline")

    text = """
    extern module MyModule "path/to/definition"
    """
    actual = parser.parse(text)
    expected = parser.result([
        declarations.extern_module("MyModule", "path/to/definition"),
    ])
    asserts.equals(env, expected, actual, "parse extern module")

    return unittest.end(env)

parse_test = unittest.make(_parse_test)

def parser_test_suite():
    return unittest.suite(
        "parser_tests",
        parse_test,
    )
