import Truth
import XCTest
@testable import ModuleMap

class TokenizerTests: XCTestCase {
  static let umbrella_hdr_str = """
  module CNIOAtomics {
      umbrella header "CNIOAtomics.h"
      export *
  }
  """

  static let submodule_str = """
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
