import Foundation

/// Specification: https://clang.llvm.org/docs/Modules.html#module-map-language
public struct Tokenizer: IteratorProtocol {
  var inputNavigator: StringNavigator

  public init(input: String) {
    inputNavigator = StringNavigator(input)
  }

  public mutating func next() -> Token? {
    guard let c = inputNavigator.current else {
      return nil
    }

    // if CharacterSet.decimalDigits.contains(anyOf: c) {
    if c.isIn(.decimalDigits) {
      return collectNumberLiteral()
    }
    // else if Character.letters.contains(c) {
    //   return collectIdentifier()
    // }

    // TODO: IMPLEMENT ME!
    return nil
  }

  mutating func collectNumberLiteral() -> Token {
    inputNavigator.mark()
    inputNavigator.next()
    while true {
      guard
        let c = inputNavigator.current,
        c.isIn(.decimalDigits)
      else {
        break
      }
      inputNavigator.next()
    }
    return .numberLiteral(String(inputNavigator.markToCurrent))
  }

  // func collectIdentifier() -> Token {
  // }
}
