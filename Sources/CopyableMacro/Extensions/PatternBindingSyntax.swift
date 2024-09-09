import SwiftSyntax

extension PatternBindingSyntax {
    var patternIdentifier: TokenSyntax? {
        pattern.as(IdentifierPatternSyntax.self)?.identifier
    }

    var type: TypeSyntax? {
        typeAnnotation?.type
    }
}
