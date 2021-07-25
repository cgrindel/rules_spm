import StructUtils

/// Spec: https://clang.llvm.org/docs/Modules.html#use-declaration
struct UseDeclaration: Withable, Equatable, ModuleMember {
  var moduleID = ""
}
