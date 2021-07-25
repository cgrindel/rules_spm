extension Parser {
  mutating func parseExportDeclaration(moduleID: String) throws -> ExportDeclaration {
    // The export token has been consumed
    var decl = ExportDeclaration()

    var continueProcessing = true
    while continueProcessing {
      let token = try nextToken("Collecting module ids for export in \(moduleID) module.")
      switch token {
      case .operator(.asterisk):
        decl.wildcard = true
        continueProcessing = false
      case let .identifier(idValue):
        decl.identifiers.append(idValue)
      case .period:
        break
      case .newLine:
        continueProcessing = false
      default:
        throw ParserError.unexpectedToken(
          token,
          "Collecting module ids for export in \(moduleID) module."
        )
      }
    }

    return decl
  }
}
