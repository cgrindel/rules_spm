"""Tests for build_declarations module"""

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm:defs.bzl", "build_declarations")

def _load_statement_test(ctx):
    env = unittest.begin(ctx)

    actual = build_declarations.load_statement(
        "@chicken//:foo.bzl",
        "chicken",
        "animal",
        "chicken",
    )
    expected = struct(
        location = "@chicken//:foo.bzl",
        symbols = ["animal", "chicken"],
    )
    asserts.equals(env, expected, actual)

    return unittest.end(env)

load_statement_test = unittest.make(_load_statement_test)

def _target_test(ctx):
    env = unittest.begin(ctx)

    target_type = "chicken_library"
    name = "smidgen"
    declaration = """
chicken_library(
    name = "smidgen"
)
"""
    actual = build_declarations.target(
        type = target_type,
        name = name,
        declaration = declaration,
    )
    expected = struct(
        type = target_type,
        name = name,
        declaration = declaration,
    )
    asserts.equals(env, expected, actual)

    return unittest.end(env)

target_test = unittest.make(_target_test)

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

def _bazel_deps_str_test(ctx):
    env = unittest.begin(ctx)

    unittest.fail(env, "IMPLEMENT ME!")

    return unittest.end(env)

bazel_deps_str_test = unittest.make(_bazel_deps_str_test)

def build_declarations_test_suite():
    return unittest.suite(
        "build_declarations_tests",
        load_statement_test,
        target_test,
        create_test,
        merge_test,
        generate_build_file_content_test,
        bazel_deps_str_test,
    )
