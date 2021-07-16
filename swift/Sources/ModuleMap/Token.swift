public enum Token {
  case reserved(ReservedWord)
  case identifier(String)
  case stringLiteral(String)
  case comment(String)
}
