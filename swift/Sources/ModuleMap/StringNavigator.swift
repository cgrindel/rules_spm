struct StringNavigator {
  let input: String
  var currentIndex: String.Index
  var markIndex: String.Index

  init(input: String) {
    self.input = input
    currentIndex = input.startIndex
    markIndex = currentIndex
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

  var markToCurrent: String {
    // TODO: IMPLEMENT ME!
    return ""
  }

}
