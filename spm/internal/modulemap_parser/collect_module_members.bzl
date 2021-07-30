load(":collect_header_declaration.bzl", "collect_header_declaration")
load(":collect_umbrella_dir_declaration.bzl", "collect_umbrella_dir_declaration")
load(":collection_results.bzl", "collection_results")
load(":errors.bzl", "errors")
load(":tokens.bzl", "tokens", rws = "reserved_words", tts = "token_types")
load("@bazel_skylib//lib:sets.bzl", "sets")

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
        # TODO: Make sure that we are counting consumed tokens correctly. I
        # think we may be double counting when we come back from collection
        # functions (e.g. return collect_result). I think that is why I
        # subtract 1 when calculating the skip_ahead below.

        consumed_count += 1
        if skip_ahead > 0:
            skip_ahead -= 1
            continue

        # Get next token
        token, err = tokens.get(parsed_tokens, idx, count = tlen)
        if err != None:
            return None, err

        # Process token

        if tokens.is_a(token, tts.curly_bracket_close):
            if len(prefix_tokens) > 0:
                return None, errors.new(
                    "Unexpected prefix tokens found at end of module member block. tokens: %s" %
                    (prefix_tokens),
                )
            break

        elif tokens.is_a(token, tts.newline):
            if len(prefix_tokens) > 0:
                return None, errors.new(
                    "Unexpected prefix tokens found before end of line. tokens: %" % (prefix_tokens),
                )

        elif tokens.is_a(token, tts.reserved, rws.umbrella):
            # The umbrella word can appear for umbrella headers or umbrella directories.
            # If the next token is header, then it is an umbrella header. Otherwise, it is an umbrella
            # directory.
            next_idx = idx + 1
            next_token, err = tokens.get(parsed_tokens, next_idx, count = tlen)
            if err != None:
                return None, err
            if tokens.is_a(next_token, tts.reserved, rws.header):
                prefix_tokens.append(token)

            else:
                if len(prefix_tokens) > 0:
                    return None, errors.new(
                        "Unexpected prefix tokens found before end of line. tokens: %" %
                        (prefix_tokens),
                    )
                collect_result, err = collect_umbrella_dir_declaration(parsed_tokens[idx:])

        elif tokens.is_a(token, tts.reserved, rws.header):
            collect_result, err = collect_header_declaration(parsed_tokens[idx:], prefix_tokens)
            prefix_tokens = []

        elif tokens.is_a(token, tts.reserved) and sets.contains(_unsupported_module_members, token.value):
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
