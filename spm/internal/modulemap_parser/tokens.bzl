load("@bazel_skylib//lib:sets.bzl", "sets")

TOKEN_TYPES = sets.make([
    "reserved",
    "identifier",
    "string_literal",
    "integer_literal",
    "float_literal",
    "comment",
    "curly_bracket_open",
    "curly_bracket_close",
    "operator",
    "newLine",
    "square_bracket_open",
    "square_bracket_close",
    "exclamation_point",
    "comma",
    "period",
])

RESERVED_WORDS = [
    "config_macros",
    "conflict",
    "exclude",
    "explicit",
    "export",
    "export_as",
    "extern",
    "framework",
    "header",
    "link",
    "module",
    "private",
    "requires",
    "textual",
    "umbrella",
    "use",
]

def create_token(type, value = None):
    return struct(
        type = type,
        value = value,
    )
