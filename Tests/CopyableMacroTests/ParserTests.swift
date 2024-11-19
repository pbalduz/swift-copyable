import SwiftSyntax
import XCTest
@testable import CopyableMacro

final class ParserTests: XCTestCase {
    func testParser_simpleLetAndVar() throws {
        let declaration = DeclSyntax(
            """
            struct Struct {
                var a: Int
                let b: Int
            }
            """
        )
        let parser = Parser()

        try parser.assert(
            declaration: declaration,
            equals: Specifications(
                name: .identifier("Struct"),
                properties: [
                    .init(name: "a", type: "Int"),
                    .init(name: "b", type: "Int"),
                ]
            )
        )
    }
    
    func testParser_multilineProperties() throws {
        let declaration = DeclSyntax(
            """
            struct Struct {
                let a: String
                let b: Int
            }
            """
        )
        let parser = Parser()

        try parser.assert(
            declaration: declaration,
            equals: Specifications(
                name: .identifier("Struct"),
                properties: [
                    .init(name: "a", type: "String"),
                    .init(name: "b", type: "Int"),
                ]
            )
        )
    }

    func testParser_differentTypeInlinedProperties() throws {
        let declaration = DeclSyntax(
            """
            struct Struct {
                let a: String, b: Int
            }
            """
        )
        let parser = Parser()

        try parser.assert(
            declaration: declaration,
            equals: Specifications(
                name: .identifier("Struct"),
                properties: [
                    .init(name: "a", type: "String"),
                    .init(name: "b", type: "Int"),
                ]
            )
        )
    }

    func testParser_sameTypeInlinedProperties() throws {
        let declaration = DeclSyntax(
            """
            struct Struct {
                let a, b: String
            }
            """
        )
        let parser = Parser()

        try parser.assert(
            declaration: declaration,
            equals: Specifications(
                name: .identifier("Struct"),
                properties: [
                    .init(name: "a", type: "String"),
                    .init(name: "b", type: "String")
                ]
            )
        )
    }

    func testParser_inlinedPropertiesMix() throws {
        let declaration = DeclSyntax(
            """
            struct Struct {
                let a, b: String, c: Int
            }
            """
        )
        let parser = Parser()

        try parser.assert(
            declaration: declaration,
            equals: Specifications(
                name: .identifier("Struct"),
                properties: [
                    .init(name: "a", type: "String"),
                    .init(name: "b", type: "String"),
                    .init(name: "c", type: "Int")
                ]
            )
        )
    }

    func testParser_initialisedVar() throws {
        let declaration = DeclSyntax(
            """
            struct Struct {
                var a: Int = 24
            }
            """
        )
        let parser = Parser()

        try parser.assert(
            declaration: declaration,
            equals: Specifications(
                name: .identifier("Struct"),
                properties: [
                    .init(name: "a", type: "Int"),
                ]
            )
        )
    }

    func testParser_withDidSetAndWillSet() throws {
        let declaration = DeclSyntax(
            """
            struct Struct {
                var a: Int {
                    didSet {
                        print("didSet")
                    }
                    willSet {
                        print("willSet")
                    }
                }
            }
            """
        )
        let parser = Parser()

        try parser.assert(
            declaration: declaration,
            equals: Specifications(
                name: .identifier("Struct"),
                properties: [.init(name: "a", type: "Int")]
            )
        )
    }

    func testParser_initialisedLetFiltered() throws {
        let declaration = DeclSyntax(
            """
            struct Struct {
                let a = 24
                let b: Int
            }
            """
        )
        let parser = Parser()

        try parser.assert(
            declaration: declaration,
            equals: Specifications(
                name: .identifier("Struct"),
                properties: [.init(name: "b", type: "Int")]
            )
        )
    }

    func testParser_computedPropertyFiltered() throws {
        let declaration = DeclSyntax(
            """
            struct Struct {
                var a: Int {
                    24
                }
                var b: Int { 8 }
                let c: Int
            }
            """
        )
        let parser = Parser()

        try parser.assert(
            declaration: declaration,
            equals: Specifications(
                name: .identifier("Struct"),
                properties: [.init(name: "c", type: "Int")]
            )
        )
    }
}

extension Parser {
    func assert(
        declaration: DeclSyntax,
        equals result: Specifications,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let specifications = try parse(declaration)
        XCTAssertEqual(
            specifications,
            result,
            file: file,
            line: line
        )
    }
}

extension Specifications.Property: Equatable {
    public static func == (lhs: Specifications.Property, rhs: Specifications.Property) -> Bool {
        lhs.name.text == rhs.name.text &&
        lhs.type.as(IdentifierTypeSyntax.self)?.name.text == rhs.type.as(IdentifierTypeSyntax.self)?.name.text
    }
}

extension Specifications: Equatable {
    public static func == (lhs: Specifications, rhs: Specifications) -> Bool {
        lhs.name.text == rhs.name.text &&
        lhs.properties == rhs.properties
    }
}

extension Specifications.Property {
    init(name: String, type: String) {
        self.init(
            name: .identifier(name),
            type: TypeSyntax(IdentifierTypeSyntax(name: .identifier(type)))
        )
    }
}
