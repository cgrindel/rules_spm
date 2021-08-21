load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal:platforms.bzl", "SPMOS_SPMARCH", "platforms")

def _create_toolchain_impl_name_test(ctx):
    env = unittest.begin(ctx)

    actual = platforms.toolchain_impl_name("macos", "x86_64")
    asserts.equals(env, "spm_macos_x86_64", actual)

    actual = platforms.toolchain_impl_name("macos", "arm64")
    asserts.equals(env, "spm_macos_arm64", actual)

    return unittest.end(env)

create_toolchain_impl_name_test = unittest.make(_create_toolchain_impl_name_test)

def _create_toolchain_name_test(ctx):
    env = unittest.begin(ctx)

    actual = platforms.toolchain_name("macos", "x86_64")
    asserts.equals(env, "spm_macos_x86_64_toolchain", actual)

    actual = platforms.toolchain_name("macos", "arm64")
    asserts.equals(env, "spm_macos_arm64_toolchain", actual)

    return unittest.end(env)

create_toolchain_name_test = unittest.make(_create_toolchain_name_test)

def _generate_toolchain_names_test(ctx):
    env = unittest.begin(ctx)

    actual = platforms.toolchain_names()
    asserts.equals(env, len(SPMOS_SPMARCH), len(actual))
    for name in actual:
        asserts.true(env, name.endswith("_toolchain"))

    return unittest.end(env)

generate_toolchain_names_test = unittest.make(_generate_toolchain_names_test)

def platforms_test_suite():
    return unittest.suite(
        "platforms_tests",
        create_toolchain_impl_name_test,
        create_toolchain_name_test,
        generate_toolchain_names_test,
    )
