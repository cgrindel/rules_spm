public struct Parser {
  let tokens: AnySequence<Token>
  // var currentModule: ModuleDeclaration?

  public init(tokens: AnySequence<Token>) {
    self.tokens = tokens
  }

  public mutating func parse() throws -> [ModuleDeclaration] {
    // var result = [ModuleDeclaration]()
    // TODO: IMPLEMENT ME!
    return []
  }

  // mutating func nextModule(parent: inout ModuleDeclaration?) throws -> ModuleDeclaration {
  //   var current = ModuleDeclaration()
  // }
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
