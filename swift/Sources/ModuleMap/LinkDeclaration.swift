import StructUtils

/// Spec: https://clang.llvm.org/docs/Modules.html#link-declaration
struct LinkDeclaration: Withable, Equatable, ModuleMember {
  var name = ""
  var framework = false
}
