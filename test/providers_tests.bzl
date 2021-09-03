load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:providers.bzl", "providers")

def _swift_module_test(ctx):
    env = unittest.begin(ctx)

    result = providers.swift_module(
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
        all_outputs = ["all"],
    )
    asserts.equals(env, expected, result)

    return unittest.end(env)

swift_module_test = unittest.make(_swift_module_test)

def _clang_module_test(ctx):
    env = unittest.begin(ctx)

    result = providers.clang_module(
        "MyModule",
        ["first.o", "second.o"],
        ["hdrs"],
        "modulemap",
        ["all"],
    )
    expected = struct(
        module_name = "MyModule",
        o_files = ["first.o", "second.o"],
        hdrs = ["hdrs"],
        modulemap = "modulemap",
        all_outputs = ["all"],
    )
    asserts.equals(env, expected, result)

    return unittest.end(env)

clang_module_test = unittest.make(_clang_module_test)

def _copy_info_test(ctx):
    env = unittest.begin(ctx)

    result = providers.copy_info("src", "dest")
    expected = struct(src = "src", dest = "dest")
    asserts.equals(env, expected, result)

    return unittest.end(env)

copy_info_test = unittest.make(_copy_info_test)

def _system_library_module_test(ctx):
    env = unittest.begin(ctx)

    actual = providers.system_library_module(
        "MyModule",
        ["first.c", "second.c"],
        ["hdrs"],
        "modulemap",
        ["all"],
    )
    expected = struct(
        module_name = "MyModule",
        c_files = ["first.c", "second.c"],
        hdrs = ["hdrs"],
        modulemap = "modulemap",
        all_outputs = ["all"],
    )
    asserts.equals(env, expected, actual)

    return unittest.end(env)

system_library_module_test = unittest.make(_system_library_module_test)

def providers_test_suite():
    return unittest.suite(
        "providers_tests",
        swift_module_test,
        clang_module_test,
        copy_info_test,
        system_library_module_test,
    )
