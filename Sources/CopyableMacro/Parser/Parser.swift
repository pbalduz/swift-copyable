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
            .compactMap { $0.filter({ syntax in syntax.isValid }) }
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

extension PatternBindingSyntax {
    fileprivate var isValid: Bool {
        guard let accessorBlock else { return true }
        guard let accessors = accessorBlock.accessors.as(AccessorDeclListSyntax.self) else {
            return false
        }
        return accessors.reduce(true) { $0 && $1.hasValidAccessorSpecifier() }
    }
}

extension AccessorDeclSyntax {
    fileprivate func hasValidAccessorSpecifier() -> Bool {
        switch accessorSpecifier.tokenKind {
        case .keyword(.didSet), .keyword(.willSet): true
        default: false
        }
    }
}
