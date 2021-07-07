load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:providers.bzl", "create_module")

def _create_module_test(ctx):
    env = unittest.begin(ctx)

    result = create_module(
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

create_module_test = unittest.make(_create_module_test)

def providers_test_suite():
    unittest.suite(
        "providers_tests",
        create_module_test,
    )
