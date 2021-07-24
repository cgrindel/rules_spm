@testable import ModuleMap
import Truth
import XCTest

class ParserExportDeclarationExtsTests: XCTestCase {
  func do_parse_ForModule_Export_test(
    _ text: String,
    file: StaticString = #file, line: UInt = #line,
    subjectConsumer: (Subject<ExportDeclaration>) -> Void
  ) throws {
    let result = try Parser.parse(text)
    assertThat(result)
      .hasCount(1)
      .firstItem {
        $0.isA(ModuleDeclaration.self, file: file, line: line) {
          $0.key(file: file, line: line, \.moduleID) {
            $0.isEqualTo("MyModule", file: file, line: line)
          }
          .key(file: file, line: line, \.members) {
            $0.hasCount(1, file: file, line: line)
              .firstItem {
                $0.isA(ExportDeclaration.self, file: file, line: line, subjectConsumer)
              }
          }
        }
      }
  }

  func test_parse_ForModule_WithExportDeclWildcard_Success() throws {
    try do_parse_ForModule_Export_test("""
    module MyModule {
        export *
    }
    """) {
      $0.isEqualTo(.with {
        $0.wildcard = true
      })
    }
  }

  func test_parse_ForModule_WithExportDeclIdentifiers_Success() throws {
    try do_parse_ForModule_Export_test("""
    module MyModule {
        export foo.bar
    }
    """) {
      $0.isEqualTo(.with {
        $0.identifiers = ["foo", "bar"]
      })
    }
  }

  func test_parse_ForModule_WithExportDeclIdentifiersAndWildcard_Success() throws {
    try do_parse_ForModule_Export_test("""
    module MyModule {
        export foo.bar.*
    }
    """) {
      $0.isEqualTo(.with {
        $0.identifiers = ["foo", "bar"]
        $0.wildcard = true
      })
    }
  }
}
