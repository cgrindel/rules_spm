extension Parser {
  mutating func parseUmbrellaDirectoryDeclaration(
    moduleID: String,
    pathToken: Token
  ) throws -> UmbrellaDirectoryDeclaration {
    guard case let .stringLiteral(path) = pathToken else {
      throw ParserError.unexpectedToken(
        pathToken,
        "Collecting the directory path for the umbrella directory declaration for \(moduleID) module."
      )
    }
    return .with { $0.path = path }
  }
}
