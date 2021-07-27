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
    collected_tokens = []
    errors = []

    chars = text.elems()
    idx = 0
    charsLen = len(chars)

    for idx in range(charsLen):
        char = chars[idx]
        if sets.contains(_whitespaces, char):
            idx += 1
        elif char == "{":
            collected_tokens.append(tokens.curly_bracket_open())
            idx += 1
        elif char == "}":
            collected_tokens.append(tokens.curly_bracket_close())
            idx += 1
        elif char == "[":
            collected_tokens.append(tokens.square_bracket_open())
            idx += 1
        elif char == "]":
            collected_tokens.append(tokens.square_bracket_close())
            idx += 1
        elif char == "!":
            collected_tokens.append(tokens.exclamation_point())
            idx += 1
        elif char == ",":
            collected_tokens.append(tokens.comma())
            idx += 1
        elif char == ".":
            collected_tokens.append(tokens.period())
            idx += 1
        else:
            # Did not recognize the char. Keep trucking.
            err = _error(char, "Unrecognized character")
            errors.append(err)
            idx += 1

    return _tokenizer_result(collected_tokens, errors)

tokenizer = struct(
    tokenize = _tokenize,
    result = _tokenizer_result,
)
