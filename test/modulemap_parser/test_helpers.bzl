load("//spm/internal/modulemap_parser:parser.bzl", "parser")
load("@bazel_skylib//lib:types.bzl", "types")
load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:errors.bzl", "errors")

def do_parse_test(env, msg, text, expected):
    if msg == None:
        fail("A message must be provided.")
    if text == None:
        fail("A text value must be provided.")
    if expected == None:
        fail("An expected value must be provied.")

    actual, err = parser.parse(text)
    asserts.equals(env, None, err, msg)
    asserts.equals(env, expected, actual, msg)

def do_failing_parse_test(env, msg, text, expected_err):
    if msg == None:
        fail("A message must be provided.")
    if text == None:
        fail("A text value must be provided.")
    if expected_err == None:
        fail("An err must be provied.")

    if types.is_string(expected_err):
        expected_err = errors.new(expected_err)

    actual, err = parser.parse(text)
    asserts.equals(env, expected_err, err, msg)
    asserts.equals(env, None, actual, msg)
