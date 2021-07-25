extension Parser {
  /// Syntax
  ///
  /// link-declaration:
  ///   link frameworkopt string-literal
  ///
  /// Spec: https://clang.llvm.org/docs/Modules.html#link-declaration
  mutating func parseLinkDeclaration(moduleID: String) throws -> LinkDeclaration {
    // We have consumed the link word.
    var decl = LinkDeclaration()

    var continueProcessing = true
    while continueProcessing {
      let token = try nextToken("Collecting a link declaration in \(moduleID) module.")
      switch token {
      case .reserved(.framework):
        decl.framework = true
      case let .stringLiteral(name):
        decl.name = name
        continueProcessing = false
      default:
        throw ParserError.unexpectedToken(
          token,
          "Collecting a link declaration in \(moduleID) module."
        )
      }
    }

    return decl
  }
}
