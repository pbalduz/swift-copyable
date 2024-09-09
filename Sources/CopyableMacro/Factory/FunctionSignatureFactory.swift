import SwiftSyntax

struct FunctionSignatureFactory: Factory {
    static func build(with specifications: Specifications) throws -> FunctionSignatureSyntax {
        let parameters = try specifications.properties.map {
            guard let parameter = $0.functionParameterSyntax else {
                throw MacroError()
            }
            return parameter
        }
        return FunctionSignatureSyntax(
            parameterClause: FunctionParameterClauseSyntax(
                parameters: FunctionParameterListSyntax(parameters).trimmingLastTrailingComma
            ),
            returnClause: ReturnClauseSyntax(
                type: IdentifierTypeSyntax(name: specifications.name)
            )
        )
    }
}

extension PatternBindingSyntax {
    fileprivate var functionParameterSyntax: FunctionParameterSyntax? {
        guard let patternIdentifier, let type else { return nil }
        return FunctionParameterSyntax(
            firstName: patternIdentifier,
            type: OptionalTypeSyntax(wrappedType: type),
            defaultValue: InitializerClauseSyntax(value: NilLiteralExprSyntax()),
            trailingComma: .commaToken()
        )
    }
}
