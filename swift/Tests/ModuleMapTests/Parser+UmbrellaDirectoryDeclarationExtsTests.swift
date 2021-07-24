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

  func test_parse_ForMoudle_WithUmbrellaDirDecl_Success() throws {
    fail("IMPLEMENT ME!")
  }
}
