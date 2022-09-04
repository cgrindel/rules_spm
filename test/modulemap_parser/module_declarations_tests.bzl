"""Tests for `module_declarations`"""

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

# buildifier: disable=bzl-visibility
load("//spm/private/modulemap_parser:declarations.bzl", "declarations")

# buildifier: disable=bzl-visibility
load("//spm/private/modulemap_parser:module_declarations.bzl", "module_declarations")

def _is_a_module_test(ctx):
    env = unittest.begin(ctx)

    module = declarations.module([])
    asserts.true(env, module_declarations.is_a_module(module))

    unprocessed_submodule = declarations.unprocessed_submodule([], [])
    asserts.false(env, module_declarations.is_a_module(unprocessed_submodule))

    return unittest.end(env)

is_a_module_test = unittest.make(_is_a_module_test)

def module_declarations_test_suite():
    return unittest.suite(
        "module_declarations_tests",
        is_a_module_test,
    )
