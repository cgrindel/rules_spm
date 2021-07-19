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

  static let submoduleStr = """
  module std [system] [extern_c] {
    module assert {
      textual header "assert.h"
      header "bits/assert-decls.h"
      export *
    }

    module complex {
      header "complex.h"
      export *
    }

    module ctype {
      header "ctype.h"
      export *
    }

    module errno {
      header "errno.h"
      header "sys/errno.h"
      export *
    }

    module fenv {
      header "fenv.h"
      export *
    }

    // ...more headers follow...
  }
  """

  func test_umbrellaHeaderExample() throws {
    let tokenizer = Tokenizer(input: Self.umbrellaHdrStr)
    let tokens = Array(tokenizer)

    // DEBUG BEGIN
    Swift.print("*** CHUCK  tokens: \(String(reflecting: tokens))")
    // DEBUG END

    fail("IMPLEMENT ME!")
  }
}
