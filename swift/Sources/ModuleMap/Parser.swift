public class Parser {
  let tokens: [Token]
  var index = 0

  public init(tokens: [Token]) {
    self.tokens = tokens
  }

  public convenience init<S>(_ sequence: S) where S: Sequence, S.Element == Token {
    self.init(tokens: Array(sequence))
  }
}
