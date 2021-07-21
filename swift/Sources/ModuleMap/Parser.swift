public struct Parser {
  var tokenIterator: AnyIterator<Token>

  public init(_ tokenIterator: AnyIterator<Token>) {
    self.tokenIterator = tokenIterator
  }

  public mutating func parse() throws -> [ModuleDeclarationProtocol] {
    // var result = [ModuleDeclaration]()
    // TODO: IMPLEMENT ME!
    return []
  }

  mutating func nextModule(
    // parent _: inout ModuleDeclaration?
  ) throws -> ModuleDeclarationProtocol? {
    guard let token = tokenIterator.next() else {
      return nil
    }

    if case let .reserved(resWord) = token, resWord == .extern {
      return try parseExternModuleDeclaration()
    } else {
      return try parseModuleDeclaration(collectedTokens: [token])
    }
  }

  mutating func parseExternModuleDeclaration() throws -> ExternModuleDeclaration {
    // TODO: IMPLEMENT ME!
    return ExternModuleDeclaration()
  }

  mutating func parseModuleDeclaration(collectedTokens _: [Token]) throws -> ModuleDeclaration {
    // TODO: IMPLEMENT ME!
    return ModuleDeclaration()
  }
}

// MARK: - Initializers

public extension Parser {
  // init<S>(_ sequence: S) where S: Sequence, S.Element == Token {
  //   self.init(tokenIterator: AnySequence(sequence))
  // }

  init<I>(iterator: I) where I: IteratorProtocol, I.Element == Token {
    self.init(AnyIterator(iterator))
  }

  init(text: String) {
    self.init(iterator: Tokenizer(text: text))
  }
}
