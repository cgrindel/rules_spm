/// Spec: https://clang.llvm.org/docs/Modules.html#module-map-language
public struct Parser {
  var tokenIterator: AnyIterator<Token>

  public init(_ tokenIterator: AnyIterator<Token>) {
    self.tokenIterator = tokenIterator
  }

  // MARK: Parse Functions

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
}

// MARK: Token Helpers

extension Parser {
  /// Returns the next token. If there is no token, throw an error with the specified message.
  mutating func nextToken(_ errorMsgExp: @autoclosure () -> String) throws -> Token {
    guard let token = tokenIterator.next() else {
      throw ParserError.endOfTokens(errorMsgExp())
    }
    return token
  }

  mutating func nextIdentifier(_ errorMsgExp: @autoclosure () -> String) throws -> String {
    let token = try nextToken(errorMsgExp())
    guard case let .identifier(idValue) = token else {
      throw ParserError.unexpectedToken(token, errorMsgExp())
    }
    return idValue
  }

  mutating func nextStringLiteral(_ errorMsgExp: @autoclosure () -> String) throws -> String {
    let token = try nextToken(errorMsgExp())
    guard case let .stringLiteral(value) = token else {
      throw ParserError.unexpectedToken(token, errorMsgExp())
    }
    return value
  }

  mutating func nextIntLiteral(_ errorMsgExp: @autoclosure () -> String) throws -> Int {
    let token = try nextToken(errorMsgExp())
    guard case let .integerLiteral(intValue) = token else {
      throw ParserError.unexpectedToken(token, errorMsgExp())
    }
    return intValue
  }

  mutating func assertNextToken(
    _ expected: Token,
    _ errorMsgExp: @autoclosure () -> String
  ) throws {
    let token = try nextToken(errorMsgExp())
    guard token == expected else {
      throw ParserError.unexpectedToken(token, errorMsgExp())
    }
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
