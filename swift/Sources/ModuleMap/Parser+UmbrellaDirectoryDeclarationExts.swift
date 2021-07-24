extension Parser {
  mutating func parseUmbrellaDirectoryDeclaration(
    moduleID: String
  ) throws -> UmbrellaDirectoryDeclaration {
    return try .with {
      $0.path = try nextStringLiteral(
        "Collecting the directory path for the umbrella directory declaration for \(moduleID) module."
      )
    }
  }
}
