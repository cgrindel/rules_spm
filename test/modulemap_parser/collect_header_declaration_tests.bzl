load("//spm/internal/modulemap_parser:declarations.bzl", "declarations")
load(":test_helpers.bzl", "do_failing_parse_test", "do_parse_test")
load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _parse_test(ctx):
    env = unittest.begin(ctx)

    do_parse_test(
        env,
        "module with single header, no qualifiers",
        text = """
        module MyModule {
            header "path/to/header.h"
        }
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                members = [
                    declarations.single_header("path/to/header.h"),
                ],
            ),
        ],
    )

    do_parse_test(
        env,
        "module with single header and attributes (ignored)",
        text = """
        module MyModule {
            header "path/to/header.h" {
                size 1234
                mtime 5678
            }
        }
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                members = [
                    declarations.single_header("path/to/header.h"),
                ],
            ),
        ],
    )

    return unittest.end(env)

parse_test = unittest.make(_parse_test)

def collect_header_declaration_test_suite():
    return unittest.suite(
        "collect_header_declaration_tests",
        parse_test,
    )
