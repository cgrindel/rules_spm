extension Parser {
  mutating func parseExportAsDeclaration(moduleID: String) throws -> ExportAsDeclaration {
    return try .with {
      $0.identifier =
        try nextIdentifier("Collecting identifier for export_as in \(moduleID) module.")
    }
  }
}
