import SwiftSyntax
import SwiftSyntaxMacros

public enum CopyableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let parser = Parser()
        let specifications = try parser.parse(declaration)

        let function = try FunctionDeclFactory.build(with: specifications)

        return [DeclSyntax(function)]
    }
}
