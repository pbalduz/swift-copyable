import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CopyablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CopyableMacro.self,
    ]
}
