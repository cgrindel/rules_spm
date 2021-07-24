enum ParserError: Error, Equatable {
  case endOfTokens(String)
  // The first arg is the actual token. The second arg is a message.
  case unexpectedToken(Token, String)
  // The first arg are the actual tokens. The second arg is a message.
  case unexpectedTokens([Token], String)
  // The first arg is a message.
  case invalidRequiresDeclaration(String)
  // The first arg is the string value that could not be converted. The second arg is a message.
  case invalidInt(String, String)
}
