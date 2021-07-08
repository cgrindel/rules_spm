load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:providers.bzl", "create_clang_module", "create_swift_module")

def _create_swift_module_test(ctx):
    env = unittest.begin(ctx)

    result = create_swift_module(
        "MyModule",
        ["first.o", "second.o"],
        "MyModule.swiftdoc",
        "MyModule.swiftmodule",
        "MyModule.swiftsourceinfo",
        ["all"],
    )
    expected = struct(
        module_name = "MyModule",
        o_files = ["first.o", "second.o"],
        swiftdoc = "MyModule.swiftdoc",
        swiftmodule = "MyModule.swiftmodule",
        swiftsourceinfo = "MyModule.swiftsourceinfo",
        all_files = ["all"],
    )
    asserts.equals(env, expected, result)

    return unittest.end(env)

create_swift_module_test = unittest.make(_create_swift_module_test)

def _create_clang_module_test(ctx):
    env = unittest.begin(ctx)

    result = create_clang_module(
        "MyModule",
        ["first.o", "second.o"],
        ["hdrs"],
        ["all"],
    )
    expected = struct(
        module_name = "MyModule",
        o_files = ["first.o", "second.o"],
        hdrs = ["hdrs"],
        all_files = ["all"],
    )
    asserts.equals(env, expected, result)

    return unittest.end(env)

create_clang_module_test = unittest.make(_create_clang_module_test)

def providers_test_suite():
    return unittest.suite(
        "providers_tests",
        create_swift_module_test,
        create_clang_module_test,
    )
