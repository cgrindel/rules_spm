extension Parser {
  mutating func parseUseDeclaration(moduleID: String) throws -> UseDeclaration {
    return try .with {
      $0.moduleID = try nextIdentifier(
        "Collecting the module id for the use declaration in \(moduleID) module."
      )
    }
  }
}
