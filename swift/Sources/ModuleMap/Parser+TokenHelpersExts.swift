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
