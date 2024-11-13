import SwiftSyntax

struct FunctionSignatureFactory: Factory {
    static func build(with specifications: Specifications) throws -> FunctionSignatureSyntax {
        FunctionSignatureSyntax(
            parameterClause: FunctionParameterClauseSyntax(
                parameters: FunctionParameterListSyntax(
                    specifications.properties.map(FunctionParameterSyntax.init(property:))
                ).trimmingLastTrailingComma
            ),
            returnClause: ReturnClauseSyntax(
                type: IdentifierTypeSyntax(name: specifications.name)
            )
        )
    }
}

extension FunctionParameterSyntax {
    fileprivate init(property: Specifications.Property) {
        self.init(
            firstName: property.name,
            type: OptionalTypeSyntax(wrappedType: property.type.trimmed),
            defaultValue: InitializerClauseSyntax(value: NilLiteralExprSyntax()),
            trailingComma: .commaToken()
        )
    }
}
