load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:declarations.bzl", "declarations")
load(":test_helpers.bzl", "do_parse_test")

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

    return unittest.end(env)

parse_test = unittest.make(_parse_test)

def collect_module_test_suite():
    return unittest.suite(
        "collect_module_tests",
        parse_test,
    )
