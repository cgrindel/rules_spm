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

def _tokenizer_result(tokens, consumed_count = 0, errors = []):
    return struct(
        tokens = tokens,
        consumed_count = consumed_count,
        errors = errors,
    )

def _error(char, msg):
    return struct(
        char = char,
        msg = msg,
    )

def _slice_after(target_list, current_idx, list_len = None):
    if not list_len:
        list_len = len(target_list)

    # If the next index is past the end, return an empty list
    # Else slice from  the next index.
    next_idx = current_idx + 1
    if next_idx >= list_len:
        return []
    return target_list[next_idx:]

def _collect_newlines(chars):
    count = 0
    for char in chars:
        if sets.contains(_newlines, char):
            count += 1
        else:
            break

    # DEBUG BEGIN
    print("*** CHUCK chars: ", chars)
    print("*** CHUCK _collect_newlines count: ", count)
    # DEBUG END

    return _tokenizer_result(
        tokens = [tokens.newLine()],
        consumed_count = count,
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

        char = chars[idx]
        if sets.contains(_whitespaces, char):
            pass
        elif sets.contains(_newlines, char):
            nl_result = _collect_newlines(_slice_after(chars, idx, list_len = charsLen))
            collected_tokens.extend(nl_result.tokens)
            skip_ahead = nl_result.consumed_count
        elif char == "{":
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
        else:
            # Did not recognize the char. Keep trucking.
            err = _error(char, "Unrecognized character")
            errors.append(err)
            idx += 1

    return _tokenizer_result(collected_tokens, consumed_count = charsLen, errors = errors)

tokenizer = struct(
    tokenize = _tokenize,
    result = _tokenizer_result,
)
