import StructUtils

/// Spec: https://clang.llvm.org/docs/Modules.html#header-declaration
struct HeaderDeclaration: Withable, Equatable, ModuleMember {
  /// Attributes that are specific to a single header file declaration.
  struct SingleQualifiers: Equatable {
    var privateHeader = false
    var textual = false
  }

  /// Specifies how the header declaration should be interpretted.
  enum DeclarationType: Equatable {
    case single(SingleQualifiers)
    case umbrella
    case exclude
  }

  /// Type of declaration
  var type: DeclarationType = .single(.init())
  /// Path to the header file.
  var path = ""

  // Attributes
  var size: Int?
  var mtime: Int?
}

extension HeaderDeclaration.SingleQualifiers {
  static func from(moduleID: String, tokens: [Token]) throws -> Self {
    var qualifiers = Self()
    for token in tokens {
      switch token {
      case .reserved(.private):
        qualifiers.privateHeader = true
      case .reserved(.textual):
        qualifiers.textual = true
      default:
        throw ParserError.unexpectedToken(
          token,
          "Collecting qualifiers for single header declaration in \(moduleID) module."
        )
      }
    }
    return qualifiers
  }
}

// enum HeaderDeclaration {
//   // Common attribute values for headers.
//   struct Attributes: Equatable {
//     var size: Int?
//     var mtime: Int?
//   }

//   struct Single: Withable, Equatable, ModuleMember {
//     // Path to the header file.
//     var path = ""
//     var privateHeader = false
//     var textual = false
//     var attributes = Attributes()
//   }

//   struct Umbrella: Withable, Equatable, ModuleMember {
//     // Path to the
//     var path = ""
//   }
// }
