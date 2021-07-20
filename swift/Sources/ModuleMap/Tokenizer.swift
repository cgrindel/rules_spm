import Foundation

/// Specification: https://clang.llvm.org/docs/Modules.html#module-map-language
public struct Tokenizer: Sequence, IteratorProtocol {
  enum TokenizerError: Error {
    case unrecognizedCharacter(Character)
  }

  // struct Handler {
  //   var beginsWithSet: CharacterSet
  //   var
  // }

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
      } else if char == "{" {
        inputNavigator.next()
        return .curlyBracketOpen
      } else if char == "}" {
        inputNavigator.next()
        return .curlyBracketClose
      } else if char == "\"" {
        return collectStringLiteral()
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

  mutating func collectStringLiteral() -> Token {
    // Currently on a string literal delimiter; move forward and mark the start of the string value.
    inputNavigator.next()
    inputNavigator.mark()
    // NOTE: Collecting parts in the event that we implement escape sequence processing.
    var parts = [String]()
    while true {
      guard let char = inputNavigator.current else {
        break
      }
      if char == "\"" {
        // Found the end of the string; capture the string value and move past the EOS delimiter
        parts.append(String(inputNavigator.markToCurrent))
        inputNavigator.next()
        break
      }
      inputNavigator.next()
    }
    return .stringLiteral(parts.joined(separator: ""))
  }
}
