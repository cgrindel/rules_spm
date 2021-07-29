load(":collection_results.bzl", "collection_results")
load(":errors.bzl", "errors")
load(":tokens.bzl", "reserved_words", "tokens")
load("@bazel_skylib//lib:sets.bzl", "sets")
load(":collect_header_declaration.bzl", "collect_header_declaration")

tts = tokens.types
rws = reserved_words

_unsupported_module_members = sets.make([
    rws.config_macros,
    rws.conflict,
    rws.requires,
    rws.use,
    rws.link,
])

def collect_module_members(parsed_tokens):
    tlen = len(parsed_tokens)
    members = []
    consumed_count = 0

    open_members_token, err = tokens.get_as(parsed_tokens, 0, tts.curly_bracket_open, count = tlen)
    if err != None:
        return None, err
    consumed_count += 1

    skip_ahead = 0
    collect_result = None
    prefix_tokens = []
    for idx in range(consumed_count, tlen - consumed_count):
        consumed_count += 1
        if skip_ahead > 0:
            skip_ahead -= 1
            continue

        # Get next token
        token, err = tokens.get(parsed_tokens, idx, count = tlen)
        if err != None:
            return None, err

        # Process token

        if token.type == tts.curly_bracket_close:
            if len(prefix_tokens) > 0:
                return None, errors.new(
                    "Unexpected prefix tokens found at end of module member block.",
                )
            break

        elif token.type == tts.newline:
            if len(prefix_tokens) > 0:
                return None, errors.new("Unexpected prefix tokens found before end of line.")

        elif token.type == tts.reserved and token.value == rws.header:
            collect_result, err = collect_header_declaration(parsed_tokens[idx:])

        elif token.type == tts.reserved and sets.contains(_unsupported_module_members, token.value):
            return None, errors.new("Unsupported module member token. token: %s" % (token))

        else:
            # Store any unrecognized tokens as prefix tokens to be processed later
            prefix_tokens.append(token)

        # Handle index advancement.
        if err != None:
            return None, err
        if collect_result:
            members.extend(collect_result.declarations)
            skip_ahead = collect_result.count - 1

    return collection_results.new(members, consumed_count), None
