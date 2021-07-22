extension Parser {
  mutating func parseExternModuleDeclaration() throws -> ExternModuleDeclaration {
    // Already found the extern token
    let moduleToken = try nextToken("Looking for the module token while parsing an extern module.")
    guard moduleToken == .reserved(.module) else {
      throw ParserError.unexpectedToken(
        moduleToken,
        "Expected the module token while parsing an extern module."
      )
    }
    let idToken = try nextToken("Looking for the module id token while parsing an extern module.")
    guard case let .identifier(moduleID) = idToken else {
      throw ParserError.unexpectedToken(
        idToken,
        "Expected the module id token while parsing an extern module."
      )
    }
    let pathToken =
      try nextToken("Looking for the module definition path token while parsing an extern module.")
    guard case let .stringLiteral(definitionPath) = pathToken else {
      throw ParserError.unexpectedToken(
        pathToken,
        "Expected a string literal token for the path while parsing an extern module."
      )
    }

    return .with {
      $0.moduleID = moduleID
      $0.definitionPath = definitionPath
    }
  }
}
