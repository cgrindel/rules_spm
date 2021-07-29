load("//spm/internal/modulemap_parser:declarations.bzl", "declarations")
load("//spm/internal/modulemap_parser:tokens.bzl", "tokens")
load(":test_helpers.bzl", "do_failing_parse_test", "do_parse_test")
load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _parse_test(ctx):
    env = unittest.begin(ctx)

    do_parse_test(
        env,
        "module without qualifiers, attributes and members",
        text = """
        module MyModule {}
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                framework = False,
                explicit = False,
                attributes = [],
                members = [],
            ),
        ],
    )

    do_parse_test(
        env,
        "module with qualifiers",
        text = """
        framework module MyModule {}
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                framework = True,
                explicit = False,
                attributes = [],
                members = [],
            ),
        ],
    )

    do_parse_test(
        env,
        "module with attributes",
        text = """
        module MyModule [system] [extern_c] {}
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                framework = False,
                explicit = False,
                attributes = ["system", "extern_c"],
                members = [],
            ),
        ],
    )

    do_failing_parse_test(
        env,
        "module with unexpected qualifier",
        text = """
        unexpected module MyModule {}
        """,
        expected_err = "Unexpected prefix token collecting module declaration. token: %s" %
                       (tokens.identifier("unexpected")),
    )

    do_failing_parse_test(
        env,
        "module with missing module id",
        text = """
        module {}
        """,
        expected_err = "Expected type identifier, but was curly_bracket_open",
    )

    do_failing_parse_test(
        env,
        "module with malformed attribute",
        text = """
        module MyModule [system {}
        """,
        expected_err = "Expected type square_bracket_close, but was curly_bracket_open",
    )

    return unittest.end(env)

parse_test = unittest.make(_parse_test)

def _parse_with_submodules_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

parse_with_submodules_test = unittest.make(_parse_with_submodules_test)

def collect_module_test_suite():
    return unittest.suite(
        "collect_module_tests",
        parse_test,
        parse_with_submodules_test,
    )
