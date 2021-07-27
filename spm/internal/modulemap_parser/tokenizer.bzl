load("//spm/internal/modulemap_parser:tokens.bzl", "tokens")
load("@bazel_skylib//lib:sets.bzl", "sets")

_whitespaces = sets.make([
    " ",  # space
    "\t",  # horizontal tab
    "\\v",  # vertical tab
    "\\b",  # backspace
])
_newlines = sets.make([
    "\n",  # line feed
    "\r",  # carriage return
    "\\f",  # form feed
])

def _tokenizer_result(tokens, errors = []):
    return struct(
        tokens = tokens,
        errors = errors,
    )

def _error(char, msg):
    return struct(
        char = char,
        msg = msg,
    )

def _tokenize(text):
    """Collects the tokens from the specified text.

    Args:
        text: A `string` from which the tokens are derived.

    Returns:
        A `list` of tokens.
    """
    tokens = []
    errors = []

    chars = text.elems()
    idx = 0
    charsLen = len(chars)

    # while idx < charsLen:
    # char = chars[idx]
    # if sets.contains(_whitespaces, char):
    #     idx += 1
    # else:
    #     # Did not recognize the char. Keep trucking.
    #     # err = _error(char, "Unrecognized character")
    #     # errors.append(err)
    #     idx += 1

    return _tokenizer_result(tokens, errors)

tokenizer = struct(
    tokenize = _tokenize,
    result = _tokenizer_result,
)
