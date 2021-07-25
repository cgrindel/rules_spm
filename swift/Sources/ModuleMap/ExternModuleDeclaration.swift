import StructUtils

public struct ExternModuleDeclaration: Withable {
  public var moduleID = ""
  public var definitionPath = ""

  public init() {}
}

extension ExternModuleDeclaration: ModuleDeclarationProtocol, ModuleMember {}
