public enum Token: Equatable {
  case reserved(ReservedWord)
  case identifier(String)
  case stringLiteral(String)
  case integerLiteral(Int)
  case floatLiteral(Float)
  case comment(String)
  case curlyBracketOpen
  case curlyBracketClose
  case `operator`(Operator)
  case newLine
  case squareBracketOpen
  case squareBracketClose
  case exclamationPoint
  case comma
}
