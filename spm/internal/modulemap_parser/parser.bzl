load(":declarations.bzl", "declarations")
load(":errors.bzl", "errors")
load(":tokenizer.bzl", "tokenizer")
load(":tokens.bzl", "reserved_words", "tokens")
load(":collection_results.bzl", "collection_results")
load(":collect_extern_module.bzl", "collect_extern_module")

tts = tokens.types
rws = reserved_words

def _parse(text):
    tokenizer_result = tokenizer.tokenize(text)
    if len(tokenizer_result.errors) > 0:
        return None, errors.new("Errors from tokenizer", tokenizer_result.errors)

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
                collect_result, err = collect_extern_module(parsed_tokens[idx:])
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

    return collected_decls, None

parser = struct(
    parse = _parse,
)
