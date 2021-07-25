@testable import ModuleMap
import Truth
import XCTest

class ParserUmbrellaDirectoryDeclarationExtsTests: XCTestCase {
  func do_parse_ForModule_UmbrellaDirectory_test(
    _ text: String,
    file: StaticString = #file, line: UInt = #line,
    subjectConsumer: (Subject<UmbrellaDirectoryDeclaration>) -> Void
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
                $0.isA(UmbrellaDirectoryDeclaration.self, file: file, line: line, subjectConsumer)
              }
          }
        }
      }
  }

  func test_parse_ForModule_WithUmbrellaDirDecl_Success() throws {
    try do_parse_ForModule_ModuleMember_test(
      expectedType: UmbrellaDirectoryDeclaration.self,
      text: """
      module MyModule {
          umbrella "path/to/header/files"
      }
      """
    ) {
      $0.isEqualTo(.with {
        $0.path = "path/to/header/files"
      })
    }
  }

  func test_parse_ForModule_WithUmbrellaDirDeclMissingPath_Fail() throws {
    let text = """
    module MyModule {
        umbrella
    }
    """
    assertThat { try Parser.parse(text) }.doesThrow(
      ParserError.unexpectedToken(
        .newLine,
        "Collecting the directory path for the umbrella directory declaration for MyModule module."
      )
    )
  }
}
