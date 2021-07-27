load("//spm/internal/modulemap_parser:tokenizer.bzl", "tokenizer")
load("//spm/internal/modulemap_parser:tokens.bzl", "tokens")
load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _tokenize_test(ctx):
    env = unittest.begin(ctx)

    text = " \t"
    asserts.equals(env, tokenizer.result([]), tokenizer.tokenize(text))

    text = "{}[]!,."
    expected = tokenizer.result([
        tokens.curly_bracket_open(),
        tokens.curly_bracket_close(),
        tokens.square_bracket_open(),
        tokens.square_bracket_close(),
        tokens.exclamation_point(),
        tokens.comma(),
        tokens.period(),
    ])
    asserts.equals(env, expected, tokenizer.tokenize(text))

    return unittest.end(env)

tokenize_test = unittest.make(_tokenize_test)

def tokenizer_test_suite():
    return unittest.suite(
        "tokenizer_tests",
        tokenize_test,
    )
