load(":tokenizer.bzl", "tokenize")

def _parse(text):
    tokens = tokenize(text)

parser = struct(
    parse = _parse,
)
