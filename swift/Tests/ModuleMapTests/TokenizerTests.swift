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
    let tokens = Array(Tokenizer(text: "0xa2B4 0XAF"))
    let expected: [Token] = [
      .integerLiteral(Int("a2B4", radix: 16)!),
      .integerLiteral(Int("AF", radix: 16)!),
    ]
    assertThat(tokens).isEqualTo(expected)
  }

  func test_base8Int() throws {
    let tokens = Array(Tokenizer(text: "0123 0456"))
    let expected: [Token] = [
      .integerLiteral(Int("123", radix: 8)!),
      .integerLiteral(Int("456", radix: 8)!),
    ]
    assertThat(tokens).isEqualTo(expected)
  }

  func test_float() throws {
    let tokens = Array(Tokenizer(text: "12.34 56.78"))
    let expected: [Token] = [.floatLiteral(12.34), .floatLiteral(56.78)]
    assertThat(tokens).isEqualTo(expected)
  }

  func test_period() throws {
    let tokens = Array(Tokenizer(text: ". foo.bar 12.34"))
    let expected: [Token] = [
      .period,
      .identifier("foo"),
      .period,
      .identifier("bar"),
      .floatLiteral(12.34),
    ]
    assertThat(tokens).isEqualTo(expected)
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
