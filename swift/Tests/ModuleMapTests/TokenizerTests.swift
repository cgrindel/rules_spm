@testable import ModuleMap
import Truth
import XCTest

class TokenizerTests: XCTestCase {
  static let umbrellaHdrStr = """
  module CNIOAtomics {
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
    assertThat(tokenizer.errors).isEmpty()
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
