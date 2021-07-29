load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load(
    "//spm/internal/modulemap_parser:declarations.bzl",
    "declarations",
    dts = "declaration_types",
)

def _module_test(ctx):
    env = unittest.begin(ctx)

    expected = struct(
        decl_type = dts.module,
        module_id = "MyModule",
        explicit = True,
        framework = False,
        attributes = ["system", "extern_c"],
        members = ["foo"],
    )
    result = declarations.module(
        module_id = "MyModule",
        explicit = True,
        framework = False,
        attributes = ["system", "extern_c"],
        members = ["foo"],
    )
    asserts.equals(env, expected, result)

    return unittest.end(env)

module_test = unittest.make(_module_test)

def _extern_module_test(ctx):
    env = unittest.begin(ctx)

    expected = struct(
        decl_type = dts.extern_module,
        module_id = "MyModule",
        definition_path = "path/to/definition",
    )
    result = declarations.extern_module(
        module_id = "MyModule",
        definition_path = "path/to/definition",
    )
    asserts.equals(env, expected, result)

    return unittest.end(env)

extern_module_test = unittest.make(_extern_module_test)

def _header_test(ctx):
    env = unittest.begin(ctx)

    expected = struct(
        decl_type = dts.single_header,
        path = "path/to/header.h",
        size = None,
        mtime = None,
        private = False,
        textual = False,
    )
    actual = declarations

    return unittest.end(env)

header_test = unittest.make(_header_test)

def declarations_test_suite():
    return unittest.suite(
        "declarations_tests",
        module_test,
        extern_module_test,
    )
