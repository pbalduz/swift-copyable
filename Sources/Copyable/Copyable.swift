@attached(member, names: arbitrary)
public macro Copyable() = #externalMacro(
    module: "CopyableMacro",
    type: "CopyableMacro"
)
