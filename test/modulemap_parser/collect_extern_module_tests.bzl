load("//spm/private/modulemap_parser:declarations.bzl", "declarations")
load(":test_helpers.bzl", "do_parse_test")
load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _parse_test(ctx):
    env = unittest.begin(ctx)

    do_parse_test(
        env,
        "parse extern module",
        text = """
        extern module MyModule "path/to/definition"
        """,
        expected = [
            declarations.extern_module("MyModule", "path/to/definition"),
        ],
    )

    return unittest.end(env)

parse_test = unittest.make(_parse_test)

def collect_extern_module_test_suite():
    return unittest.suite(
        "collect_extern_module_tests",
        parse_test,
    )
