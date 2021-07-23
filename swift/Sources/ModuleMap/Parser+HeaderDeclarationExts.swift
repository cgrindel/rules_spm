extension Parser {
  /// Syntax
  ///
  /// header-declaration:
  ///   privateopt textualopt header string-literal header-attrsopt
  ///   umbrella header string-literal header-attrsopt
  ///   exclude header string-literal header-attrsopt
  ///
  /// header-attrs:
  ///   '{' header-attr* '}'
  ///
  /// header-attr:
  ///   size integer-literal
  ///   mtime integer-literal
  ///
  /// Spec: https://clang.llvm.org/docs/Modules.html#header-declaration
  mutating func parseHeaderDeclaration(
    moduleID: String,
    prefixTokens: [Token]
  ) throws -> HeaderDeclaration {
    // The tokens up through the header token have been consumed.
    var decl = HeaderDeclaration()

    // Parse the prefix tokens to determine the type of declaration

    // for prefixToken in prefixTokens {
    //   switch prefixToken {
    //   case .reserved(.umbrella):
    //     decl.type = .umbrella
    //   case .reserved(.exclude):
    //     decl.type = .exclude
    //   case
    //   }
    // }
    if let prefixToken = prefixTokens.first {
      switch prefixToken {
      case .reserved(.umbrella):
        decl.type = .umbrella
      case .reserved(.exclude):
        decl.type = .exclude
      default:
        decl.type = .single(try .from(moduleID: moduleID, tokens: prefixTokens))
      }
    }

    return decl
  }
}
