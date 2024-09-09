import SwiftSyntax
import SwiftSyntaxMacros

public enum CopyableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let extractor = Parser()
        let specifications = try extractor.extract(from: declaration)

        let function = try FunctionDeclFactory.build(with: specifications)

        return [DeclSyntax(function)]
    }
}
