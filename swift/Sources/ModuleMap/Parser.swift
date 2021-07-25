/// Spec: https://clang.llvm.org/docs/Modules.html#module-map-language
public struct Parser {
  var tokenIterator: AnyIterator<Token>

  public init(_ tokenIterator: AnyIterator<Token>) {
    self.tokenIterator = tokenIterator
  }

  // MARK: Parse Functions

  public mutating func parse() throws -> [ModuleDeclarationProtocol] {
    var result = [ModuleDeclarationProtocol]()
    while true {
      guard let module = try nextModule() else {
        break
      }
      result.append(module)
    }
    return result
  }

  mutating func nextModule() throws -> ModuleDeclarationProtocol? {
    var prefixTokens = [Token]()
    while true {
      guard let token = tokenIterator.next() else {
        return nil
      }

      switch token {
      case .newLine:
        break
      case .reserved(.extern):
        guard prefixTokens.isEmpty else {
          throw ParserError.unexpectedTokens(prefixTokens, "Collecting module declarations.")
        }
        return try parseExternModuleDeclaration()
      case .reserved(.module):
        return try parseModuleDeclaration(prefixTokens: prefixTokens)
      default:
        prefixTokens.append(token)
      }
    }
  }
}

// MARK: - Initializers

public extension Parser {
  init<I>(iterator: I) where I: IteratorProtocol, I.Element == Token {
    self.init(AnyIterator(iterator))
  }

  init(text: String) {
    self.init(iterator: Tokenizer(text: text))
  }
}

// MARK: - Parse Helper Function

public extension Parser {
  /// Parse the provided string and return the module declarations.
  static func parse(_ text: String) throws -> [ModuleDeclarationProtocol] {
    var parser = Parser(text: text)
    return try parser.parse()
  }
}
