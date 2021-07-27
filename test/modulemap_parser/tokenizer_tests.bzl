load("//spm/internal/modulemap_parser:tokenizer.bzl", "tokenizer")
load("//spm/internal/modulemap_parser:tokens.bzl", "tokens")
load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

def _tokenize_test(ctx):
    env = unittest.begin(ctx)

    text = " \t"
    expected = tokenizer.result(
        tokens = [],
    )
    asserts.equals(env, expected, tokenizer.tokenize(text), "consume whitespace")

    text = "{}[]!,."
    expected = tokenizer.result(
        tokens = [
            tokens.curly_bracket_open(),
            tokens.curly_bracket_close(),
            tokens.square_bracket_open(),
            tokens.square_bracket_close(),
            tokens.exclamation_point(),
            tokens.comma(),
            tokens.period(),
        ],
    )
    asserts.equals(env, expected, tokenizer.tokenize(text), "consume no value tokens")

    text = "{\n\r}"
    expected = tokenizer.result(
        tokens = [
            tokens.curly_bracket_open(),
            tokens.newline(),
            tokens.curly_bracket_close(),
        ],
    )
    result = tokenizer.tokenize(text)
    asserts.equals(env, expected, result, "consume multiple new lines")

    text = "{\n}"
    expected = tokenizer.result(
        tokens = [
            tokens.curly_bracket_open(),
            tokens.newline(),
            tokens.curly_bracket_close(),
        ],
    )
    result = tokenizer.tokenize(text)
    asserts.equals(env, expected, result, "consume a single new line")

    text = "a1234 module"
    expected = tokenizer.result(
        tokens = [
            tokens.identifier("a1234"),
            tokens.reserved("module"),
        ],
    )
    result = tokenizer.tokenize(text)
    asserts.equals(env, expected, result, "consume identifiers and reserved words")

    return unittest.end(env)

tokenize_test = unittest.make(_tokenize_test)

def tokenizer_test_suite():
    return unittest.suite(
        "tokenizer_tests",
        tokenize_test,
    )
