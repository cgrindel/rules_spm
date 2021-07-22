extension Parser {
  mutating func parseModuleDeclaration(currentToken: Token) throws -> ModuleDeclaration {
    var module = ModuleDeclaration()
    var continueProcessing = true

    // Collect the qualififers and the module token
    var token = currentToken
    while continueProcessing {
      switch token {
      case .reserved(.module):
        continueProcessing = false
      case .reserved(.explicit):
        module.explicit = true
      case .reserved(.framework):
        module.framework = true
      default:
        throw ParserError.unexpectedToken(token, "Collecting qualifiers for module declaration.")
      }
      if continueProcessing {
        token = try nextToken("Collecting qualifiers for module declaration.")
      }
    }

    // Expect the module id
    token = try nextToken("Looking for the module id token while parsing a module.")
    guard case let .identifier(moduleID) = token else {
      throw ParserError.unexpectedToken(
        token,
        "Expected the module id token while parsing a module."
      )
    }
    module.moduleID = moduleID

    // Collect any attributes until the beginning of the module members section
    continueProcessing = true
    while continueProcessing {
      token = try nextToken("Collecting attributes for \(moduleID) module.")
      switch token {
      case .curlyBracketOpen:
        continueProcessing = false
      case .squareBracketOpen:
        let attribute = try parseModuleAttribute(moduleID: moduleID)
        module.attributes.append(attribute)
      default:
        throw ParserError.unexpectedToken(token, "Collecting attributes for \(moduleID) module.")
      }
    }

    // Collect the module members
    while true {
      guard let member = try nextModuleMember() else {
        break
      }
      module.members.append(member)
    }

    return module
  }

  mutating func parseModuleAttribute(moduleID: String) throws -> String {
    // Already collected the square bracket open.
    let attribValueToken = try nextToken("Collecting attribute for \(moduleID) module.")
    guard case let .identifier(attribValue) = attribValueToken else {
      throw ParserError.unexpectedToken(
        attribValueToken,
        "Collecting attribute for \(moduleID) module."
      )
    }
    let closeToken = try nextToken("Collecting closing square bracket (]) for \(moduleID) module.")
    guard closeToken == .squareBracketClose else {
      throw ParserError.unexpectedToken(
        closeToken,
        "Collecting closing square bracket (]) for \(moduleID) module."
      )
    }
    return attribValue
  }

  mutating func nextModuleMember() throws -> ModuleMember? {
    while true {
      guard let token = tokenIterator.next() else {
        return nil
      }

      switch token {
      case .newLine:
        continue
      case .curlyBracketClose:
        // Found the end of the members section
        return nil
      default:
        // TODO: IMPLEMENT ME!
        return nil
      }
    }
  }
}
