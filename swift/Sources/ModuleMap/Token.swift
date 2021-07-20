public enum Token: Equatable {
  case reserved(ReservedWord)
  case identifier(String)
  case stringLiteral(String)
  case numberLiteral(String)
  case comment(String)
  case curlyBracketOpen
  case curlyBracketClose
  case `operator`(Operator)
}
