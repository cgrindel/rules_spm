import Foundation

public extension CharacterSet {
  /// Valid characters to start an identifier.
  /// Spec: http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf
  /// Section: 6.4.2.1
  static let c99IdentifierBeginningCharacters: CharacterSet = {
    var charSet = CharacterSet.letters
    charSet.insert(charactersIn: "_")
    return charSet
  }()

  static let c99IdenfitiferCharacters: CharacterSet = {
    var charSet = CharacterSet.c99IdentifierBeginningCharacters
    charSet.formUnion(.decimalDigits)
    return charSet
  }()

  static let c99Operators: CharacterSet = {
    CharacterSet(charactersIn: "*")
  }()

  static let c99NumberBeginningCharacters: CharacterSet = {
    .decimalDigits
  }()

  static let c99OctalDigits: CharacterSet = {
    .init(charactersIn: "01234567")
  }()

  static let c99HexadecimalDigits: CharacterSet = {
    .init(charactersIn: "0123456789abcdefABCDEF")
  }()

  static let c99NumberCharacters: CharacterSet = {
    var charSet = CharacterSet.decimalDigits
    charSet.formUnion(.c99HexadecimalDigits)
    charSet.insert(charactersIn: ".,")
    return charSet
  }()
}
