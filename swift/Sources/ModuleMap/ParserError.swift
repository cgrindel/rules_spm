enum ParserError: Error, Equatable {
  case endOfTokens(String)
  // The first arg is the actual token. The second arg is a message.
  case unexpectedToken(Token, String)
  // The first arg is a message.
  case invalidRequiresDeclaration(String)
}
