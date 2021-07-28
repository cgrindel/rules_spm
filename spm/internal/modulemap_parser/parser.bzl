load(":tokenizer.bzl", "tokenizer")
load(":tokens.bzl", "reserved_words", "tokens")

def _collection_result(declarations, count):
    """Creates a collection result `struct`.

    Args:
        declarations: The declarations that were collected.
        count: The number of tokens that were collected.

    Returns:
        A `struct` representing the data that was collected.
    """
    return struct(
        declarations = declarations,
        count = count,
    )

def _parser_result(declarations = []):
    return struct(
        declarations = declarations,
    )

def _error(msg, child_errors = []):
    return struct(
        msg = msg,
        child_errors = child_errors,
    )

def _collect_extern_module(parsed_tokens):
    """Collect an extern module declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#module-declaration

    Syntax:

    extern module module-id string-literal

    Args:
        parsed_tokens: A `list` of tokens.

    Returns:
        A `tuple` where the first item is the collection result and the second is an
        error `struct` as returned from _error().
    """
    extern_token, err = tokens.next(parsed_tokens, 0)
    if err:
        return None, _error("Failed to find extern token.")

    return _collection_result([], 0)

def _parse(text):
    tokenizer_result = tokenizer.tokenize(text)
    if len(tokenizer_result.errors) > 0:
        return None, _error("Errors from tokenizer", tokenizer_result.errors)

    parsed_tokens = tokenizer_result.tokens
    tokens_cnt = len(parsed_tokens)

    collected_decls = []
    skip_ahead = 0
    prefix_tokens = []
    for idx in range(tokens_cnt):
        if skip_ahead > 0:
            skip_ahead -= 1
            continue

        token = parsed_tokens[idx]
        collect_result = None

        if token.type == tokens.types.newline:
            pass

        elif token.type == tokens.types.reserved:
            if token.value == reserved_words.extern:
                collect_result, err = _collect_extern_module(parsed_tokens[idx:])
                if err:
                    return None, err

            elif token.value == reserved_words.module:
                # TODO: IMPLEMENT ME!
                pass

            else:
                prefix_tokens.append(token)

        else:
            prefix_tokens.append(token)

        if collect_result:
            collected_decls.extend(collect_result.declarations)
            skip_ahead = collect_result.count - 1

    return _parser_result(collected_decls), None

parser = struct(
    parse = _parse,
    result = _parser_result,
)
