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

def _single_header_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

single_header_test = unittest.make(_single_header_test)

def _umbrella_header_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

umbrella_header_test = unittest.make(_umbrella_header_test)

def _exclude_header_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

exclude_header_test = unittest.make(_exclude_header_test)

def _umbrella_directory_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

umbrella_directory_test = unittest.make(_umbrella_directory_test)

def declarations_test_suite():
    return unittest.suite(
        "declarations_tests",
        module_test,
        extern_module_test,
        single_header_test,
        umbrella_header_test,
        exclude_header_test,
        umbrella_directory_test,
    )
