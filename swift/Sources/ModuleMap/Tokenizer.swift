/// Specification: https://clang.llvm.org/docs/Modules.html#module-map-language
public struct Tokenizer: IteratorProtocol {
  let input: String
  var index = 0

  public init(input: String) {
    self.input = input
  }

  public mutating func next() -> Token? {
    // TODO: IMPLEMENT ME!
    return nil
  }
}
