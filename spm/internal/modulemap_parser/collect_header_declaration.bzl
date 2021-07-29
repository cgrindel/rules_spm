load(":errors.bzl", "errors")
load(":collection_results.bzl", "collection_results")
load(":tokens.bzl", "reserved_words", "tokens")

def collect_header_declaration(parsed_tokens, prefix_tokens):
    """Collect a header declaration.

    Spec: https://clang.llvm.org/docs/Modules.html#header-declaration

    Syntax:
        header-declaration:
          privateopt textualopt header string-literal header-attrsopt
          umbrella header string-literal header-attrsopt
          exclude header string-literal header-attrsopt

        header-attrs:
          '{' header-attr* '}'

        header-attr:
          size integer-literal
          mtime integer-literal

    Args:
        parsed_tokens: A `list` of tokens.
        prefix_tokens: A `list` of tokens that have been consumed but not yet processed.

    Returns:
        A `tuple` where the first item is the collection result and the second is an
        error `struct` as returned from errors.create().
    """
    return None, errors.new("IMPLEMEMT ME!")
