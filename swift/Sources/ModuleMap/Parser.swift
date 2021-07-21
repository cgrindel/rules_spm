public struct Parser {
  let tokens: AnySequence<Token>

  public init(tokens: AnySequence<Token>) {
    self.tokens = tokens
  }

  public mutating func parse() throws -> [ModuleDeclaration] {
    // TODO: IMPLEMENT ME!
    return []
  }
}

// MARK: - Initializers

public extension Parser {
  init<S>(_ sequence: S) where S: Sequence, S.Element == Token {
    self.init(tokens: AnySequence(sequence))
  }

  init(text: String) {
    self.init(Tokenizer(text: text))
  }
}
