import SwiftSyntax

struct FunctionDeclFactory: Factory {
    static func build(with specifications: Specifications) throws -> FunctionDeclSyntax {
        FunctionDeclSyntax(
            name: .identifier("copy"),
            signature: try FunctionSignatureFactory.build(with: specifications),
            bodyBuilder: {
                FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(baseName: specifications.name).trimmed,
                    leftParen: .leftParenToken(),
                    arguments: LabeledExprListSyntax(
                        specifications.properties.map(LabeledExprSyntax.init(property:))
                    )
                    .trimmingLastTrailingComma,
                    rightParen: .rightParenToken()
                )
            }
        )
    }
}

extension LabeledExprSyntax {
    fileprivate init(property: Specifications.Property) {
        self.init(
            label: property.name,
            colon: .colonToken(),
            expression: InfixOperatorExprSyntax(
                leftOperand: DeclReferenceExprSyntax(baseName: property.name),
                operator: BinaryOperatorExprSyntax(operator: .binaryOperator("??")),
                rightOperand: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                    name: property.name
                )
            ),
            trailingComma: .commaToken()
        )
    }
}
