import StructUtils

/// Spec: https://clang.llvm.org/docs/Modules.html#export-declaration
struct ExportDeclaration: Withable, Equatable, ModuleMember {
  /// Can have zero or more identifiers (e.g. first.second => ["first", "second"])
  var identifiers = [String]()
  // If the end of the asterisk was specified, then this is a wildcard export.
  var wildcard = false
}
