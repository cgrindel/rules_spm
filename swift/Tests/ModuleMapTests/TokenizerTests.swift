@testable import ModuleMap
import Truth
import XCTest

class TokenizerTests: XCTestCase {
  static let umbrellaHdrStr = """
  module CNIOAtomics [system] {
      umbrella header "CNIOAtomics.h"
      export *
  }
  """

  func test_umbrellaHeaderExample() throws {
    let tokenizer = Tokenizer(text: Self.umbrellaHdrStr)
    let tokens = Array(tokenizer)
    let expected: [Token] = [
      .reserved(.module),
      .identifier("CNIOAtomics"),
      .squareBracketOpen,
      .identifier("system"),
      .squareBracketClose,
      .curlyBracketOpen,
      .newLine,
      .reserved(.umbrella),
      .reserved(.header),
      .stringLiteral("CNIOAtomics.h"),
      .newLine,
      .reserved(.export),
      .operator(.asterisk),
      .newLine,
      .curlyBracketClose,
    ]
    assertThat(tokens).isEqualTo(expected)
  }

  func test_base10Int() throws {
    let tokens = Array(Tokenizer(text: "1234 5678"))
    let expected: [Token] = [.integerLiteral(1234), .integerLiteral(5678)]
    assertThat(tokens).isEqualTo(expected)
  }

  func test_base16Int() throws {
    fail("IMPLEMENT ME!")
  }

  func test_base8Int() throws {
    fail("IMPLEMENT ME!")
  }

  func test_float() throws {
    fail("IMPLEMENT ME!")
  }

  // static let submoduleStr = """
  // module std [system] [extern_c] {
  //   module assert {
  //     textual header "assert.h"
  //     header "bits/assert-decls.h"
  //     export *
  //   }

  //   module complex {
  //     header "complex.h"
  //     export *
  //   }

  //   module ctype {
  //     header "ctype.h"
  //     export *
  //   }

  //   module errno {
  //     header "errno.h"
  //     header "sys/errno.h"
  //     export *
  //   }

  //   module fenv {
  //     header "fenv.h"
  //     export *
  //   }

  //   // ...more headers follow...
  // }
  // """
}
