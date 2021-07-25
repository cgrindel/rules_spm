import Foundation

/// Specification: https://clang.llvm.org/docs/Modules.html#module-map-language
public struct Tokenizer: Sequence, IteratorProtocol {
  enum TokenizerError: Error {
    case unrecognizedCharacter(Character)
  }

  var inputNavigator: StringNavigator
  var errors: [Error] = []

  public init(text input: String) {
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
      } else if char == "[" {
        inputNavigator.next()
        return .squareBracketOpen
      } else if char == "]" {
        inputNavigator.next()
        return .squareBracketClose
      } else if char == "!" {
        inputNavigator.next()
        return .exclamationPoint
      } else if char == "," {
        inputNavigator.next()
        return .comma
      } else if char == "." {
        inputNavigator.next()
        return .period
      } else if char == "\"" {
        return collectStringLiteral()
      } else if char.isIn(.newlines) {
        return collectNewline()
      } else if char.isIn(.c99Operators) {
        return collectOperator()
      } else if char.isIn(.c99NumberBeginningCharacters) {
        return collectNumberConstant()
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

  mutating func collectNewline() -> Token {
    // inputNavigator.mark()
    // inputNavigator.next()
    // while true {
    //   guard
    //     let char = inputNavigator.current,
    //     char.isIn(.newlines)
    //   else {
    //     break
    //   }
    //   inputNavigator.next()
    // }
    inputNavigator.next(whileIn: .newlines)
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

  mutating func collectOperator() -> Token? {
    inputNavigator.next()
    // We only support one operator
    return .operator(.asterisk)
  }

  mutating func collectNumberConstant() -> Token? {
    // Currently on the first character of the number constant.
    guard let firstChar = inputNavigator.current else {
      return nil
    }

    // Check for octal or hex value
    if firstChar == "0" {
      inputNavigator.next()
      if let secondChar = inputNavigator.current {
        // Hex value
        if secondChar.isIn(["x", "X"]) {
          inputNavigator.next()
          inputNavigator.mark()
          inputNavigator.next(whileIn: .c99HexadecimalDigits)
          guard let hexValue = Int(String(inputNavigator.markToCurrent), radix: 16) else {
            return nil
          }
          return .integerLiteral(hexValue)
        }
        // Octal value
        inputNavigator.mark()
        inputNavigator.next(whileIn: .c99OctalDigits)
        guard let octalValue = Int(String(inputNavigator.markToCurrent), radix: 8) else {
          return nil
        }
        return .integerLiteral(octalValue)
      }
      // No more characters. So, the value is 0
      return .integerLiteral(0)
    }

    // Collect the rest of the number digits and see if Swift can parse it.
    // This is some weak sauce, but is good enough for the current modulemap parsing.
    inputNavigator.mark()
    inputNavigator.next(whileIn: .c99NumberCharacters)
    let numStr = inputNavigator.markToCurrent
    if let int = Int(numStr) {
      return .integerLiteral(int)
    }
    if let float = Float(numStr) {
      return .floatLiteral(float)
    }
    return nil
  }
}
