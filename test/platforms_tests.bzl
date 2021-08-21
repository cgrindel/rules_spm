load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _create_toolchain_impl_name_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

create_toolchain_impl_name_test = unittest.make(_create_toolchain_impl_name_test)

def _create_toolchain_name_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

create_toolchain_name_test = unittest.make(_create_toolchain_name_test)

def _generate_toolchain_names_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

generate_toolchain_names_test = unittest.make(_generate_toolchain_names_test)

def platforms_test_suite():
    return unittest.suite(
        "platforms_tests",
        create_toolchain_impl_name_test,
        create_toolchain_name_test,
        generate_toolchain_names_test,
    )
