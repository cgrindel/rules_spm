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

  func testSomething() {
    fail("IMPLEMENT ME!")
  }
}
