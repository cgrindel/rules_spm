extension Parser {
  /// Syntax
  ///
  /// requires-declaration:
  ///   requires feature-list
  ///
  /// feature-list:
  ///   feature (',' feature)*
  ///
  /// feature:
  ///   !opt identifier
  ///
  mutating func parseRequiresDeclaration(moduleID: String) throws -> RequiresDeclaration {
    // Already read the requires reserved word
    var decl = RequiresDeclaration()
    var currentFeature = RequiresDeclaration.Feature()

    var continueProcessing = true
    while continueProcessing {
      let token =
        try nextToken("Collecting features for requires declaration in \(moduleID) module.")
      switch token {
      case .exclamationPoint:
        currentFeature.compatible = false
      case let .identifier(featureName):
        currentFeature.name = featureName
        decl.features.append(currentFeature)
      case .comma:
        currentFeature = RequiresDeclaration.Feature()
      case .newLine:
        continueProcessing = false
      default:
        throw ParserError.unexpectedToken(
          token,
          "Collecting features for requires declaration in \(moduleID) module."
        )
      }
    }

    guard decl.features.count > 0 else {
      throw ParserError.invalidRequiresDeclaration(
        "No features were found for requires declaration in \(moduleID) module"
      )
    }
    return decl
  }
}
