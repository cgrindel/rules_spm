import Foundation

struct StringNavigator {
  let input: String
  var currentIndex: String.Index
  var markIndex: String.Index

  init(_ input: String) {
    self.input = input
    currentIndex = input.startIndex
    markIndex = currentIndex
  }

  mutating func reset() {
    currentIndex = input.startIndex
    markIndex = input.startIndex
  }

  mutating func mark() {
    markIndex = currentIndex
  }

  mutating func previous() {
    guard currentIndex != input.startIndex else {
      return
    }
    currentIndex = input.index(before: currentIndex)
  }

  mutating func next() {
    guard currentIndex != input.endIndex else {
      return
    }
    currentIndex = input.index(after: currentIndex)
  }

  var current: Character? {
    guard currentIndex != input.endIndex else {
      return nil
    }
    return input[currentIndex]
  }

  var markToCurrent: Substring {
    return input[markIndex ..< currentIndex]
  }
}

// MARK: Navigate With CharacterSet

extension StringNavigator {
  mutating func next(whileIn charSet: CharacterSet) {
    while true {
      guard let char = current, char.isIn(charSet) else {
        break
      }
      next()
    }
  }
}
