load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:files.bzl", "contains_path", "is_hdr_file", "is_modulemap_file", "is_target_file")

def _is_target_file_test(ctx):
    env = unittest.begin(ctx)

    target_name = "MyModule"

    file = struct(is_directory = True)
    asserts.false(env, is_target_file(target_name, file))

    file = struct(is_directory = False, short_path = "Sources/NotMyModule/Chicken.swift")
    asserts.false(env, is_target_file(target_name, file))

    file = struct(is_directory = False, short_path = "Sources/MyModule/Chicken.swift")
    asserts.true(env, is_target_file(target_name, file))

    file = struct(is_directory = False, short_path = "Sources/MyModule/Subdir/Chicken.swift")
    asserts.true(env, is_target_file(target_name, file))

    file = struct(is_directory = False, short_path = "Tests/MyModule/Chicken.swift")
    asserts.true(env, is_target_file(target_name, file))

    return unittest.end(env)

is_target_file_test = unittest.make(_is_target_file_test)

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

def _is_modulemap_file_test(ctx):
    env = unittest.begin(ctx)

    file = struct(is_directory = True, basename = "module.modulemap")
    asserts.false(env, is_modulemap_file(file))

    file = struct(is_directory = False, basename = "module.modulemap")
    asserts.true(env, is_modulemap_file(file))

    return unittest.end(env)

is_modulemap_file_test = unittest.make(_is_modulemap_file_test)

def _contains_path_test(ctx):
    env = unittest.begin(ctx)

    file = struct(path = "/path/to/code/Sources/MyModule/include/MyModule.h")
    asserts.true(env, contains_path(file, "Sources/MyModule/include"))

    file = struct(path = "/path/to/code/Sources/NotMyModule/include/MyModule.h")
    asserts.false(env, contains_path(file, "Sources/MyModule/include"))

    return unittest.end(env)

contains_path_test = unittest.make(_contains_path_test)

def files_test_suite():
    return unittest.suite(
        "files_tests",
        is_target_file_test,
        is_hdr_file_test,
        is_modulemap_file_test,
        contains_path_test,
    )
