extension Parser {
  /// Syntax
  ///
  /// explicitopt frameworkopt module module-id attributesopt '{' module-member* '}'
  ///
  /// attributes:
  ///   attribute attributesopt
  ///
  /// attribute:
  ///   '[' identifier ']'
  ///
  /// Spec: https://clang.llvm.org/docs/Modules.html#module-declaration
  mutating func parseModuleDeclaration(
    isSubmodule: Bool,
    prefixTokens: [Token]
  ) throws -> ModuleDeclaration {
    // We have collected the module word.
    var module = ModuleDeclaration()
    var continueProcessing = true

    // Collect the qualififers and the module token
    for token in prefixTokens {
      switch token {
      case .reserved(.explicit):
        guard isSubmodule else {
          throw ParserError.unexpectedToken(
            token,
            "The explicit qualifier can only exist on submodules."
          )
        }
        module.explicit = true
      case .reserved(.framework):
        module.framework = true
      default:
        throw ParserError.unexpectedToken(token, "Collecting qualifiers for module declaration.")
      }
    }

    module.moduleID = try nextIdentifier("Looking for the module id token while parsing a module.")

    // Collect any attributes until the beginning of the module members section
    continueProcessing = true
    while continueProcessing {
      let token = try nextToken("Collecting attributes for \(module.moduleID) module.")
      switch token {
      case .curlyBracketOpen:
        continueProcessing = false
      case .squareBracketOpen:
        let attribute = try parseModuleAttribute(moduleID: module.moduleID)
        module.attributes.append(attribute)
      default:
        throw ParserError.unexpectedToken(
          token,
          "Collecting attributes for \(module.moduleID) module."
        )
      }
    }

    // Collect the module members
    while true {
      guard let member = try nextModuleMember(moduleID: module.moduleID) else {
        break
      }
      module.members.append(member)
    }

    return module
  }

  mutating func parseModuleAttribute(moduleID: String) throws -> String {
    // Already collected the square bracket open.
    let attribValue = try nextIdentifier("Collecting attribute for \(moduleID) module.")
    try assertNextToken(
      .squareBracketClose,
      "Collecting closing square bracket (]) for \(moduleID) module."
    )
    return attribValue
  }

  /// Syntax
  ///
  /// module-member:
  ///   requires-declaration
  ///   header-declaration
  ///   umbrella-dir-declaration
  ///   submodule-declaration
  ///   export-declaration
  ///   export-as-declaration
  ///   use-declaration
  ///   link-declaration
  ///   config-macros-declaration
  ///   conflict-declaration
  ///
  mutating func nextModuleMember(moduleID: String) throws -> ModuleMember? {
    var prefixTokens = [Token]()
    while true {
      guard let token = tokenIterator.next() else {
        return nil
      }

      switch token {
      case .newLine:
        guard prefixTokens.isEmpty else {
          throw ParserError.unexpectedTokens(
            prefixTokens,
            "Prefix tokens found before end of line in \(moduleID) module."
          )
        }
        continue
      case .curlyBracketClose:
        guard prefixTokens.isEmpty else {
          throw ParserError.unexpectedTokens(
            prefixTokens,
            "Prefix tokens found at end of module member block in \(moduleID) module."
          )
        }
        // Found the end of the members section
        return nil
      case .reserved(.requires):
        guard prefixTokens.isEmpty else {
          throw ParserError.unexpectedTokens(
            prefixTokens,
            "Prefix tokens found for requires declaration in \(moduleID) module."
          )
        }
        return try parseRequiresDeclaration(moduleID: moduleID)
      case .reserved(.umbrella):
        // The umbrella word can appear for umbrella headers or umbrella directories.
        // If the next token is header, then it is an umbrella header. Otherwise, it is an umbrella
        // directory.
        let nextToken = try nextToken("Checking if umbrella header or directory.")
        if nextToken == .reserved(.header) {
          prefixTokens.append(.reserved(.umbrella))
          return try parseHeaderDeclaration(moduleID: moduleID, prefixTokens: prefixTokens)
        }
        guard prefixTokens.isEmpty else {
          throw ParserError.unexpectedTokens(
            prefixTokens,
            "Prefix tokens found for umbrella directory declaration in \(moduleID) module."
          )
        }
        return try parseUmbrellaDirectoryDeclaration(moduleID: moduleID, pathToken: nextToken)
      case .reserved(.header):
        return try parseHeaderDeclaration(moduleID: moduleID, prefixTokens: prefixTokens)
      case .reserved(.export):
        return try parseExportDeclaration(moduleID: moduleID)
      case .reserved(.exportAs):
        return try parseExportAsDeclaration(moduleID: moduleID)
      case .reserved(.extern):
        guard prefixTokens.isEmpty else {
          throw ParserError.unexpectedTokens(prefixTokens, "Collecting module declarations.")
        }
        return try parseExternModuleDeclaration()
      case .reserved(.module):
        return try parseModuleDeclaration(isSubmodule: true, prefixTokens: prefixTokens)
      case .reserved(.use):
        return try parseUseDeclaration(moduleID: moduleID)
      case .reserved(.link):
        return try parseLinkDeclaration(moduleID: moduleID)
      case .reserved(.configMacros), .reserved(.conflict):
        throw ParserError.unsupported(token, "This module member is currently not supported.")
      default:
        prefixTokens.append(token)
      }
    }
  }
}
