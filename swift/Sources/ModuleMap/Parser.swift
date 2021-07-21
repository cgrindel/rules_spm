/// Spec: https://clang.llvm.org/docs/Modules.html#module-map-language
public struct Parser {
  var tokenIterator: AnyIterator<Token>

  public init(_ tokenIterator: AnyIterator<Token>) {
    self.tokenIterator = tokenIterator
  }

  /// Returns the next token. If there is no token, throw an error with the specified message.
  mutating func nextToken(_ errorMsgExp: @autoclosure () -> String) throws -> Token {
    guard let token = tokenIterator.next() else {
      throw ParserError.endOfTokens(errorMsgExp())
    }
    return token
  }

  public mutating func parse() throws -> [ModuleDeclarationProtocol] {
    var result = [ModuleDeclarationProtocol]()
    while true {
      guard let module = try nextModule() else {
        break
      }
      result.append(module)
    }
    return result
  }

  mutating func nextModule() throws -> ModuleDeclarationProtocol? {
    while true {
      guard let token = tokenIterator.next() else {
        return nil
      }

      switch token {
      case .newLine:
        continue
      case .reserved(.extern):
        return try parseExternModuleDeclaration()
      default:
        return try parseModuleDeclaration(currentToken: token)
      }
    }
  }

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

    // TODO: Use Withable
    var externModule = ExternModuleDeclaration()
    externModule.moduleID = moduleID
    externModule.definitionPath = definitionPath
    return externModule
  }

  mutating func parseModuleDeclaration(currentToken: Token) throws -> ModuleDeclaration {
    var module = ModuleDeclaration()

    // Collect the qualififers and the module token
    var token = currentToken
    while true {
      switch token {
      case .reserved(.module):
        break
      case .reserved(.explicit):
        module.explicit = true
      case .reserved(.framework):
        module.framework = true
      default:
        throw ParserError.unexpectedToken(token, "Collecting qualifiers for module declaration.")
      }
      token = try nextToken("Collecting qualifiers for module declaration.")
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
    while true {
      token = try nextToken("Collecting attributes for \(moduleID) module.")
      switch token {
      case .curlyBracketOpen:
        break
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
    return attribValue
  }

  mutating func nextModuleMember() throws -> ModuleMember? {
    // TODO: IMPLEMENT ME!
    return nil
  }
}

// MARK: - Initializers

public extension Parser {
  init<I>(iterator: I) where I: IteratorProtocol, I.Element == Token {
    self.init(AnyIterator(iterator))
  }

  init(text: String) {
    self.init(iterator: Tokenizer(text: text))
  }
}

// MARK: - Parse Helper Function

public extension Parser {
  /// Parse the provided string and return the module declarations.
  static func parse(_ text: String) throws -> [ModuleDeclarationProtocol] {
    var parser = Parser(text: text)
    return try parser.parse()
  }
}
