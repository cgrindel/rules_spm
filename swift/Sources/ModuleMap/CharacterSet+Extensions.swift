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
}
