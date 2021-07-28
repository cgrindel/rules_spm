load(":tokenizer.bzl", "tokenizer")
load(":tokens.bzl", "tokens")

def _parser_result(declarations = [], errors = []):
    return struct(
        declarations = declarations,
        errors = errors,
    )

def _parse(text):
    tokenizer_result = tokenizer.tokenize(text)
    if len(tokenizer_result.errors) > 0:
        return _parser_result(errors = tokenizer_result.errors)

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

        if token.type == tokens.types.newline:
            pass
        else:
            prefix_tokens.append(token)

    return _parser_result(collected_decls)

parser = struct(
    parse = _parse,
    result = _parser_result,
)
