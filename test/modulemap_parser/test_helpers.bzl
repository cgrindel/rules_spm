load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//spm/internal/modulemap_parser:parser.bzl", "parser")

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
