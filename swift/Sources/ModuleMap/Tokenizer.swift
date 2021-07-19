import Foundation

/// Specification: https://clang.llvm.org/docs/Modules.html#module-map-language
public struct Tokenizer: Sequence, IteratorProtocol {
  var inputNavigator: StringNavigator

  public init(input: String) {
    inputNavigator = StringNavigator(input)
  }

  public mutating func next() -> Token? {
    guard let char = inputNavigator.current else {
      return nil
    }

    if char.isIn(.c99IdentifierBeginningCharacters) {
      return collectIdentifier()
    }
    // else if char.isIn(.decimalDigits) {
    //   return collectNumberLiteral()
    // }

    return nil
  }

  // mutating func collectNumberLiteral() -> Token {
  //   inputNavigator.mark()
  //   inputNavigator.next()
  //   while true {
  //     guard
  //       let char = inputNavigator.current,
  //       char.isIn(.decimalDigits)
  //     else {
  //       break
  //     }
  //     inputNavigator.next()
  //   }
  //   return .numberLiteral(String(inputNavigator.markToCurrent))
  // }

  mutating func collectIdentifier() -> Token {
    inputNavigator.mark()
    inputNavigator.next()
    while true {
      guard
        let char = inputNavigator.current,
        char.isIn(.c99IdenfitiferCharacters)
      else {
        break
      }
      inputNavigator.next()
    }
    let idStr = String(inputNavigator.markToCurrent)
    if let reservedWord = ReservedWord(rawValue: idStr) {
      return .reserved(reservedWord)
    }
    return .identifier(idStr)
  }
}
