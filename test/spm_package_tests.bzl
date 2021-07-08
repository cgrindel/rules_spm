load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:spm_package.bzl", "is_hdr_file", "is_module_file")

def _is_module_file_test(ctx):
    env = unittest.begin(ctx)

    target_name = "MyModule"

    file = struct(is_directory = True)
    asserts.false(env, is_module_file(target_name, file))

    file = struct(is_directory = False, short_path = "Sources/NotMyModule/Chicken.swift")
    asserts.false(env, is_module_file(target_name, file))

    file = struct(is_directory = False, short_path = "Sources/MyModule/Chicken.swift")
    asserts.true(env, is_module_file(target_name, file))

    file = struct(is_directory = False, short_path = "Sources/MyModule/Subdir/Chicken.swift")
    asserts.true(env, is_module_file(target_name, file))

    file = struct(is_directory = False, short_path = "Tests/MyModule/Chicken.swift")
    asserts.true(env, is_module_file(target_name, file))

    return unittest.end(env)

is_module_file_test = unittest.make(_is_module_file_test)

def _is_hdr_file_test(ctx):
    env = unittest.begin(ctx)

    file = struct(is_directory = True, extension = "h")
    asserts.false(env, is_hdr_file(file))

    file = struct(is_directory = False, extension = "c")
    asserts.false(env, is_hdr_file(file))

    file = struct(is_directory = False, extension = "h", dirname = "Sources/MyModule")
    asserts.false(env, is_hdr_file(file))

    file = struct(is_directory = False, extension = "h", dirname = "Sources/MyModule/include")
    asserts.true(env, is_hdr_file(file))

    return unittest.end(env)

is_hdr_file_test = unittest.make(_is_hdr_file_test)

def spm_package_test_suite():
    return unittest.suite(
        "spm_package_tests",
        is_module_file_test,
        is_hdr_file_test,
    )
