public enum Token {
  case reserved(ReservedWord)
  case identifier(String)
  case stringLiteral(String)
  case numberLiteral(String)
  case comment(String)
}
