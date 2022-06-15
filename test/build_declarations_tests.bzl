load("@bazel_skylib//lib:unittest.bzl", "unittest")

def _target_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

target_test = unittest.make(_target_test)

def _load_statement_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

load_statement_test = unittest.make(_load_statement_test)

def _create_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

create_test = unittest.make(_create_test)

def _merge_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

merge_test = unittest.make(_merge_test)

def _generate_build_file_content_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

generate_build_file_content_test = unittest.make(_generate_build_file_content_test)

def _create_bazel_deps_str_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

create_bazel_deps_str_test = unittest.make(_create_bazel_deps_str_test)

def build_declarations_test_suite():
    return unittest.suite(
        "build_declarations_tests",
        target_test,
        load_statement_test,
        create_test,
        merge_test,
        generate_build_file_content_test,
        create_bazel_deps_str_test,
    )
