load(":tokens.bzl", "tokens")
load(":character_sets.bzl", "character_sets")
load("@bazel_skylib//lib:sets.bzl", "sets")

def _tokenizer_result(tokens, errors = []):
    return struct(
        tokens = tokens,
        errors = errors,
    )

def _collection_result(chars = [], errors = []):
    """Creates a collection result `struct`.

    Args:
        chars: A `list` of the tokens that were collected.
        errors: A `list` of errors that were found.

    Returns:
        A `struct` representing the data that was collected.
    """
    return struct(
        chars = chars,
        errors = errors,
    )

def _error(char, msg):
    return struct(
        char = char,
        msg = msg,
    )

def _collect_chars_in_set(chars, target_set):
    collected_chars = []
    for char in chars:
        if sets.contains(target_set, char):
            collected_chars.append(char)
        else:
            break

    return _collection_result(
        chars = collected_chars,
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

    skip_ahead = 0
    for idx in range(charsLen):
        if skip_ahead > 0:
            skip_ahead -= 1
            continue

        collect_result = None
        char = chars[idx]
        if char == "{":
            collected_tokens.append(tokens.curly_bracket_open())
        elif char == "}":
            collected_tokens.append(tokens.curly_bracket_close())
        elif char == "[":
            collected_tokens.append(tokens.square_bracket_open())
        elif char == "]":
            collected_tokens.append(tokens.square_bracket_close())
        elif char == "!":
            collected_tokens.append(tokens.exclamation_point())
        elif char == ",":
            collected_tokens.append(tokens.comma())
        elif char == ".":
            collected_tokens.append(tokens.period())
        elif sets.contains(character_sets.whitespaces, char):
            pass
        elif sets.contains(character_sets.newlines, char):
            collect_result = _collect_chars_in_set(chars[idx:], character_sets.newlines)
            collected_tokens.append(tokens.newline())
        elif sets.contains(tokens.operators, char):
            # If we implement more than just asterisk for operators, this will need to be
            # revisited.
            collect_result = _collect_chars_in_set(chars[idx:], character_sets.operators)
            collected_tokens.append(tokens.operator(collect_result.chars))
        else:
            # Did not recognize the char. Keep trucking.
            err = _error(char, "Unrecognized character")
            errors.append(err)
            idx += 1

        if collect_result:
            skip_ahead = len(collect_result.chars) - 1

    return _tokenizer_result(collected_tokens, errors = errors)

tokenizer = struct(
    tokenize = _tokenize,
    result = _tokenizer_result,
)
