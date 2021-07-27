load("//spm/internal/modulemap_parser:tokens.bzl", "tokens")

def _tokenize(text):
    """Collects the tokens from the specified text.

    Args:
        text: A `string` from which the tokens are derived.

    Returns:
        A `list` of tokens.
    """
    pass

tokenizer = struct(
    tokenize = _tokenize,
)
