import Algorithms
import SwiftSyntax

struct Parser {
    func parse(_ declaration: SyntaxProtocol) throws -> Specifications {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroError()
        }

        let properties = structDecl
            .memberBlock
            .members
            .compactMap(\.variables)
            .flatMap(\.chunksByType)
            .flatMap(Specifications.Property.parsed(from:))

        guard !properties.isEmpty else {
            throw MacroError()
        }

        return Specifications(
            name: structDecl.name,
            properties: properties
        )
    }
}

extension PatternBindingListSyntax {
    fileprivate var chunksByType: [Slice<PatternBindingListSyntax>] {
        chunked {
            let left = !$0.containsType && $0.containsTrailingComma
            let right = left || $1.containsType
            return left && right
        }
    }
}

extension Specifications.Property {
    fileprivate static func parsed(from slice: Slice<PatternBindingListSyntax>) -> [Self] {
        guard let type = slice.last?.typeAnnotation?.type else {
            return []
        }
        return slice.compactMap { binding in
            guard let name = binding.patternIdentifier else { return nil }
            return Specifications.Property(
                name: name,
                type: type
            )
        }
    }
}
