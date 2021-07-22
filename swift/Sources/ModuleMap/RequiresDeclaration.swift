import StructUtils

/// Spec: https://clang.llvm.org/docs/Modules.html#requires-declaration
struct RequiresDeclaration: Withable, Equatable {
  struct Feature: Withable, Equatable {
    var name = ""
    var compatible = true

    public init() {}

    public init(
      name: String,
      compatible: Bool = true
    ) {
      self.name = name
      self.compatible = compatible
    }
  }

  var features = [Feature]()

  public init() {}
}

extension RequiresDeclaration: ModuleMember {}
