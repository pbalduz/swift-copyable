import SwiftSyntax

struct FunctionDeclFactory: Factory {
    static func build(with specifications: Specifications) throws -> FunctionDeclSyntax {
        let arguments = try specifications.properties.map {
            guard let argument = $0.labeledExprListSyntax else {
                throw MacroError()
            }
            return argument
        }
        return FunctionDeclSyntax(
            name: .identifier("copy"),
            signature: try FunctionSignatureFactory.build(with: specifications),
            bodyBuilder: {
                FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(baseName: specifications.name).trimmed,
                    leftParen: .leftParenToken(),
                    arguments: LabeledExprListSyntax(arguments).trimmingLastTrailingComma,
                    rightParen: .rightParenToken()
                )
            }
        )
    }
}

extension PatternBindingSyntax {
    fileprivate var labeledExprListSyntax: LabeledExprSyntax? {
        guard let patternIdentifier else { return nil }
        return LabeledExprSyntax(
            label: patternIdentifier,
            colon: .colonToken(),
            expression: InfixOperatorExprSyntax(
                leftOperand: DeclReferenceExprSyntax(baseName: patternIdentifier),
                operator: BinaryOperatorExprSyntax(operator: .binaryOperator("??")),
                rightOperand: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(baseName: .keyword(.`self`)),
                    name: patternIdentifier
                )
            ),
            trailingComma: .commaToken()
        )
    }
}
