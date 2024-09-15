import SwiftSyntax

extension PatternBindingSyntax {
    var patternIdentifier: TokenSyntax? {
        pattern.as(IdentifierPatternSyntax.self)?.identifier
    }

    var type: TypeSyntax? {
        typeAnnotation?.type
    }

    var containsType: Bool {
        typeAnnotation != nil
    }

    var containsTrailingComma: Bool {
        trailingComma != nil
    }
}
