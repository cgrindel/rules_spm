@testable import ModuleMap
import Truth
import XCTest

class ParserHeaderDeclarationExtsTests: XCTestCase {
  func test_parse_ForModule_WithSingleHeaderDeclNoQualifiers_Success() throws {
    let text = """
    module MyModule {
        header "path/to/header.h"
    }
    """
    let result = try Parser.parse(text)
    assertThat(result)
      .hasCount(1)
      .firstItem {
        $0.isA(ModuleDeclaration.self) {
          $0.key(\.moduleID) { $0.isEqualTo("MyModule") }
            .key(\.members) {
              $0.hasCount(1)
                .firstItem {
                  $0.isA(HeaderDeclaration.self) { $0.isEqualTo(.with {
                    $0.type = .single(.init())
                    $0.path = "path/to/header.h"
                  }) }
                }
            }
        }
      }
  }

  func test_parse_ForModule_WithSingleHeaderDeclNoQualifiersWithAttribs_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithSingleHeaderDeclAsPrivate_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithSingleHeaderDeclAsTextual_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithUmbrellaHeader_Success() throws {
    fail("IMPLEMENT ME!")
  }

  func test_parse_ForModule_WithExcludeHeader_Success() throws {
    fail("IMPLEMENT ME!")
  }
}
