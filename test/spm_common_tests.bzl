load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/private:spm_common.bzl", "spm_common")

def _create_clang_hdrs_key_test(ctx):
    env = unittest.begin(ctx)

    result = spm_common.create_clang_hdrs_key("foo-kit", "FooKit")
    asserts.equals(env, "foo-kit/FooKit", result)

    return unittest.end(env)

create_clang_hdrs_key_test = unittest.make(_create_clang_hdrs_key_test)

def _split_clang_hdrs_key_test(ctx):
    env = unittest.begin(ctx)

    pkg_name, target_name = spm_common.split_clang_hdrs_key("foo-kit/FooKit")
    asserts.equals(env, "foo-kit", pkg_name)
    asserts.equals(env, "FooKit", target_name)

    return unittest.end(env)

split_clang_hdrs_key_test = unittest.make(_split_clang_hdrs_key_test)

def _is_include_hdr_path_test(ctx):
    env = unittest.begin(ctx)

    asserts.true(env, spm_common.is_include_hdr_path("foo/bar/include/chicken.h"))
    asserts.false(env, spm_common.is_include_hdr_path("foo/bar/chicken.h"))

    # Find headers that are not directly under the include directory.
    # Example: https://github.com/SDWebImage/libwebp-Xcode/tree/master/include/webp
    asserts.true(env, spm_common.is_include_hdr_path("foo/bar/include/chicken/smidgen.h"))
    asserts.false(env, spm_common.is_include_hdr_path("foo/bar/not_include/chicken/smidgen.h"))
    asserts.false(env, spm_common.is_include_hdr_path("foo/bar/include_not/chicken/smidgen.h"))

    return unittest.end(env)

is_include_hdr_path_test = unittest.make(_is_include_hdr_path_test)

def spm_common_test_suite():
    return unittest.suite(
        "spm_common_tests",
        create_clang_hdrs_key_test,
        split_clang_hdrs_key_test,
        is_include_hdr_path_test,
    )
