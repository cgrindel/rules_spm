// MARK: - Header Declaration Parsing

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

    let path =
      try nextStringLiteral("Collecting the path for header declaration in \(moduleID) module.")
    decl.path = path

    var continueProcessing = true
    var expectCurlyBracketClose = false
    while continueProcessing {
      let token =
        try nextToken("Collecting end of header declaration for \(path) in \(moduleID) module.")
      switch token {
      case .newLine:
        continueProcessing = false
      case .curlyBracketOpen:
        expectCurlyBracketClose = true
        try parseHeaderDeclarationAttribute(moduleID: moduleID, path: path, decl: &decl)
      case .curlyBracketClose:
        guard expectCurlyBracketClose else {
          throw ParserError.unexpectedToken(
            token,
            "Collecting header attributes for \(path) in \(moduleID) module."
          )
        }
        continueProcessing = false
      default:
        throw ParserError.unexpectedToken(
          token,
          "Collecting end of header declaration for \(path) in \(moduleID) module."
        )
      }
    }

    return decl
  }

  mutating func parseHeaderDeclarationAttribute(
    moduleID: String,
    path: String,
    decl: inout HeaderDeclaration
  ) throws {
    var continueProcessing = true
    while continueProcessing {
      let token = try nextToken(
        "Collecting attributes for header declaration for \(path) in \(moduleID) module."
      )
      switch token {
      case .identifier("size"):
        decl.size = try nextIntLiteral(
          "Collecting the size attribute value for \(path) in \(moduleID) module."
        )
      case .identifier("mtime"):
        decl.mtime = try nextIntLiteral(
          "Collecting the mtime attribute value for \(path) in \(moduleID) module."
        )
      case .newLine:
        break
      case .curlyBracketClose:
        continueProcessing = false
      default:
        throw ParserError.unexpectedToken(
          token,
          "Collecting header declaration attributes for \(moduleID) module."
        )
      }
    }
  }
}

// MARK: - Single Header Qualifiers Parsing

extension HeaderDeclaration.SingleQualifiers {
  static func from(moduleID: String, tokens: [Token]) throws -> Self {
    var qualifiers = Self()
    for token in tokens {
      switch token {
      case .reserved(.private):
        qualifiers.privateHeader = true
      case .reserved(.textual):
        qualifiers.textual = true
      default:
        throw ParserError.unexpectedToken(
          token,
          "Collecting qualifiers for single header declaration in \(moduleID) module."
        )
      }
    }
    return qualifiers
  }
}
