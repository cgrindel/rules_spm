/// Spec: https://clang.llvm.org/docs/Modules.html#module-map-language
public struct Parser {
  enum ParserError: Error {
    case endOfTokens(String)
    // The first arg is the actual token. The second arg is a message.
    case unexpectedToken(Token, String)
  }

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
    guard let token = tokenIterator.next() else {
      return nil
    }

    // if case let .reserved(resWord) = token, resWord == .extern {
    if token == .reserved(.extern) {
      return try parseExternModuleDeclaration()
    } else {
      return try parseModuleDeclaration(collectedTokens: [token])
    }
  }

  mutating func parseExternModuleDeclaration() throws -> ExternModuleDeclaration {
    // Already found the extern token
    let moduleToken = try nextToken("Looking for the module token while parsing an extern module.")
    guard moduleToken == .reserved(.module) else {
      throw ParserError.unexpectedToken(
        moduleToken,
        "Expected the module token while parsing an extern module"
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
        "Expected the module id token while parsing an extern module."
      )
    }

    // TODO: Use Withable
    var externModule = ExternModuleDeclaration()
    externModule.moduleID = moduleID
    externModule.definitionPath = definitionPath
    return externModule
  }

  mutating func parseModuleDeclaration(collectedTokens _: [Token]) throws -> ModuleDeclaration {
    // TODO: IMPLEMENT ME!
    return ModuleDeclaration()
  }
}

// MARK: - Initializers

public extension Parser {
  // init<S>(_ sequence: S) where S: Sequence, S.Element == Token {
  //   self.init(tokenIterator: AnySequence(sequence))
  // }

  init<I>(iterator: I) where I: IteratorProtocol, I.Element == Token {
    self.init(AnyIterator(iterator))
  }

  init(text: String) {
    self.init(iterator: Tokenizer(text: text))
  }
}
