import Foundation

/// Specification: https://clang.llvm.org/docs/Modules.html#module-map-language
public struct Tokenizer: Sequence, IteratorProtocol {
  enum TokenizerError: Error {
    case unrecognizedCharacter(Character)
  }

  var inputNavigator: StringNavigator
  var errors: [Error] = []

  public init(input: String) {
    inputNavigator = StringNavigator(input)
  }

  public mutating func next() -> Token? {
    while true {
      guard let char = inputNavigator.current else {
        return nil
      }

      if char.isIn(.whitespaces) {
        // Ignore the character
        inputNavigator.next()
      } else if char.isIn(.newlines) {
        return collectNewLines()
      } else if char.isIn(.c99IdentifierBeginningCharacters) {
        return collectIdentifier()
      }
      // We did not recognize the character. Note it and keep trucking.
      else {
        errors.append(TokenizerError.unrecognizedCharacter(char))
        // Ignore the character
        inputNavigator.next()
      }
    }
  }

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

  mutating func collectNewLines() -> Token {
    inputNavigator.mark()
    inputNavigator.next()
    while true {
      guard
        let char = inputNavigator.current,
        char.isIn(.newlines)
      else {
        break
      }
      inputNavigator.next()
    }
    return .newLine
  }
}
