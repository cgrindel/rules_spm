load("@bazel_skylib//lib:unittest.bzl", "unittest")
load("//spm/internal/modulemap_parser:parser.bzl", "parser")
load("//spm/internal/modulemap_parser:declarations.bzl", "declarations")
load(":test_helpers.bzl", "do_parse_test")

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
