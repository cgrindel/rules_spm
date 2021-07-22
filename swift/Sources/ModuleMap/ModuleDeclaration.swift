import StructUtils

public struct ModuleDeclaration: Withable {
  public var moduleID = ""

  // Qualifiers
  public var explicit = false
  public var framework = false

  // Attributes
  public var attributes = [String]()

  // Module members
  public var members = [ModuleMember]()

  public init() {}
}

extension ModuleDeclaration: ModuleDeclarationProtocol {}
