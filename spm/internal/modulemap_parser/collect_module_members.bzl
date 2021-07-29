load(":collection_results.bzl", "collection_results")
load(":errors.bzl", "errors")
load(":tokens.bzl", "reserved_words", "tokens")

tts = tokens.types
rws = reserved_words

def collect_module_members(parsed_tokens):
    tlen = len(parsed_tokens)
    members = []
    consumed_count = 0

    skip_ahead = 0
    collect_result = None
    prefix_tokens = []
    for idx in range(tlen):
        consumed_count += 1
        if skip_ahead > 0:
            skip_ahead -= 1
            continue

        # Get next token
        token, err = tokens.get(parsed_tokens, idx, count = tlen)
        if err != None:
            return None, err

        # Process token

        if token.type == tts.newline:
            if len(prefix_tokens) > 0:
                return None, errors.new("Unexpected prefix tokens found before end of line.")

    return collection_results.new(members, consumed_count), None
