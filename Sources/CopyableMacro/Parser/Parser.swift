import SwiftSyntax
import SwiftParser

struct Parser {
    func extract(from declaration: DeclGroupSyntax) throws -> Specifications {
        guard let structDecl = declaration.asStructDecl else {
            throw MacroError()
        }

        let properties = declaration.propertiesDecl
        guard !properties.isEmpty else {
            throw MacroError()
        }

        return Specifications(
            name: structDecl.name,
            properties: properties
        )
    }
}

struct Specifications {
    let name: TokenSyntax
    let properties: PatternBindingListSyntax
}

extension DeclGroupSyntax {
    var asStructDecl: StructDeclSyntax? {
        self.as(StructDeclSyntax.self)
    }

    var propertiesDecl: PatternBindingListSyntax {
        self.memberBlock
            .members
            .reduce(PatternBindingListSyntax()) { accumulated, member in
                var nextResult = accumulated
                if let bindings = member.decl.as(VariableDeclSyntax.self)?.bindings {
                    nextResult.append(contentsOf: bindings)
                }
                return nextResult
            }
    }
}
