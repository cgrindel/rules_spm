load(":errors.bzl", "errors")
load(":collection_results.bzl", "collection_results")
load(":tokens.bzl", "tokens", rws = "reserved_words", tts = "token_types")
load(":declarations.bzl", "declarations", dts = "declaration_types")

def collect_umbrella_dir_declaration(parsed_tokens):
    return None, errors.new("IMPLEMENT ME!")
