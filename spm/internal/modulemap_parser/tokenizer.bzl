load("//spm/internal/modulemap_parser:tokens.bzl", "tokens")
load("@bazel_skylib//lib:sets.bzl", "sets")

_whitespaces = sets.make([
    " ",  # space
    "\t",  # horizontal tab
    # "\\v",  # vertical tab
    # "\\b",  # backspace
])
_newlines = sets.make([
    "\n",  # line feed
    "\r",  # carriage return
    # "\\f",  # form feed
])

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

# def _slice_after(target_list, current_idx, list_len = None):
#     if not list_len:
#         list_len = len(target_list)
#     # If the next index is past the end, return an empty list
#     # Else slice from  the next index.
#     next_idx = current_idx + 1
#     if next_idx >= list_len:
#         return []
#     return target_list[next_idx:]

# def _collect_newlines(chars):
#     count = 0
#     for char in chars:
#         if sets.contains(_newlines, char):
#             count += 1
#         else:
#             break

#     return _tokenizer_result(
#         tokens = [tokens.newLine()],
#         consumed_count = count,
#     )

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
        elif sets.contains(_whitespaces, char):
            pass
        elif sets.contains(_newlines, char):
            collect_result = _collect_chars_in_set(chars[idx:], _newlines)
            collected_tokens.append(tokens.newline())
        elif sets.contains(tokens.operators, char):
            # If we implement more than just asterisk for operators, this will need to be
            # revisited.
            collect_result = _collect_chars_in_set(chars[idx:], tokens.operators)
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
