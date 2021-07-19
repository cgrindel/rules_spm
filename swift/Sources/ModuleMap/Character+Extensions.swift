import Foundation

public extension Character {
  /// Returns true if all of the Unicode scalars in this Character (grapheme cluster) are in the
  /// specified set. Otherwise false.
  func isIn(_ characterSet: CharacterSet) -> Bool {
    // for scalar in unicodeScalars {
    //   guard characterSet.contains(scalar) else {
    //     return false
    //   }
    // }
    // return true
    let subset = CharacterSet(unicodeScalars)
    return subset.isSubset(of: characterSet)
  }
}
