"""Tests for collect_module."""

load("@bazel_skylib//lib:unittest.bzl", "unittest")

# buildifier: disable=bzl-visibility
load("//spm/private/modulemap_parser:declarations.bzl", "declarations")

# buildifier: disable=bzl-visibility
load("//spm/private/modulemap_parser:tokens.bzl", "tokens")
load(":test_helpers.bzl", "do_failing_parse_test", "do_parse_test")

def _collect_module_test(ctx):
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
        "module with members",
        text = """
        module MyModule {
            header "SomeHeader.h"
        }
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                framework = False,
                explicit = False,
                attributes = [],
                members = [
                    struct(attribs = None, decl_type = "single_header", path = "SomeHeader.h", private = False, textual = False),
                ],
            ),
        ],
    )

    do_parse_test(
        env,
        "two modules with members and exports with newlines",
        text = """
        module MyModule {
            header "SomeHeader.h"
            header "SomeOtherHeader.h"
            export *
        }

        module MyModuleTwo {
            header "SecondHeader.h"
            header "ThirdHeader.h"
            export *
        }
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                framework = False,
                explicit = False,
                attributes = [],
                members = [
                    struct(attribs = None, decl_type = "single_header", path = "SomeHeader.h", private = False, textual = False),
                    struct(attribs = None, decl_type = "single_header", path = "SomeOtherHeader.h", private = False, textual = False),
                    struct(decl_type = "export", identifiers = [], wildcard = True),
                ],
            ),
            declarations.module(
                module_id = "MyModuleTwo",
                framework = False,
                explicit = False,
                attributes = [],
                members = [
                    struct(attribs = None, decl_type = "single_header", path = "SecondHeader.h", private = False, textual = False),
                    struct(attribs = None, decl_type = "single_header", path = "ThirdHeader.h", private = False, textual = False),
                    struct(decl_type = "export", identifiers = [], wildcard = True),
                ],
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

    do_parse_test(
        env,
        "module with submodule",
        text = """
        module MyModule {
            module A {
                header "A.h"
            }
        }
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                framework = False,
                explicit = False,
                attributes = [],
                members = [
                    declarations.module(module_id = "A", members = [
                        struct(attribs = None, decl_type = "single_header", path = "A.h", private = False, textual = False),
                    ]),
                ],
            ),
        ],
    )

    do_parse_test(
        env,
        "module with explicit submodule",
        text = """
        module MyModule {
            umbrella "MyLib"
            explicit module * {
                export *
            }
        }
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                framework = False,
                explicit = False,
                attributes = [],
                members = [
                    declarations.umbrella_directory("MyLib"),
                    declarations.module(module_id = "MyLib", explicit = True, members = [
                        struct(decl_type = "export", identifiers = [], wildcard = True),
                    ]),
                ],
            ),
        ],
    )

    do_parse_test(
        env,
        "module with explicit submodule and umbrella header",
        text = """
        module MyModule {
            umbrella header "header.h"
            explicit module * {
                export *
            }
        }
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                framework = False,
                explicit = False,
                attributes = [],
                members = [
                    declarations.umbrella_header(path = "header.h"),
                    declarations.module(module_id = "header.h", explicit = True, members = [
                        struct(decl_type = "export", identifiers = [], wildcard = True),
                    ]),
                ],
            ),
        ],
    )

    do_parse_test(
        env,
        "standard submodule",
        text = """
        module MyModule {
            header "header.h"
            module A {
                header "A.h"
                export *
            }
        }
        """,
        expected = [
            declarations.module(
                module_id = "MyModule",
                framework = False,
                explicit = False,
                attributes = [],
                members = [
                    struct(attribs = None, decl_type = "single_header", path = "header.h", private = False, textual = False),
                    declarations.module(module_id = "A", members = [
                        struct(attribs = None, decl_type = "single_header", path = "A.h", private = False, textual = False),
                        struct(decl_type = "export", identifiers = [], wildcard = True),
                    ]),
                ],
            ),
        ],
    )

    do_failing_parse_test(
        env,
        "explicit module",
        text = """
        explicit module MyModule {}
        """,
        expected_err = "The explicit qualifier can only exist on submodules.",
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

collect_module_test = unittest.make(_collect_module_test)

def collect_module_test_suite():
    return unittest.suite(
        "collect_module_tests",
        collect_module_test,
    )
