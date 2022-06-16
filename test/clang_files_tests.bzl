load("@bazel_skylib//lib:unittest.bzl", "unittest")
load("//spm:defs.bzl", "clang_files")

def _is_include_hdr_path_test(ctx):
    env = unittest.begin(ctx)

    asserts.true(env, clang_files.is_include_hdr_path("foo/bar/include/chicken.h"))
    asserts.true(env, clang_files.is_include_hdr_path("foo/public/chicken.h"))
    asserts.true(env, clang_files.is_include_hdr_path("public/chicken.h"))
    asserts.false(env, clang_files.is_include_hdr_path("foo/bar/chicken.h"))

    # Find headers that are not directly under the include directory.
    # Example: https://github.com/SDWebImage/libwebp-Xcode/tree/master/include/webp
    asserts.true(env, clang_files.is_include_hdr_path("foo/bar/include/chicken/smidgen.h"))
    asserts.false(env, clang_files.is_include_hdr_path("foo/bar/not_include/chicken/smidgen.h"))
    asserts.false(env, clang_files.is_include_hdr_path("foo/bar/include_not/chicken/smidgen.h"))

    return unittest.end(env)

is_include_hdr_test = unittest.make(_is_include_hdr_test)

# TODO: Add unit tests for other functions.

def clang_files_test_suite():
    return unittest.suite(
        "clang_files_tests",
        is_include_hdr_test,
    )
