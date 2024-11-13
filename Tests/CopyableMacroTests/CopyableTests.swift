import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CopyableMacro)

import CopyableMacro

let testMacros: [String: Macro.Type] = [
    "Copyable": CopyableMacro.self,
]

final class swift_copyableTests: XCTestCase {
    func testCopyable() throws {
        assertMacroExpansion(
            """
            @Copyable
            struct Struct {
                let a: String
                let b: Int
                var c: Int
                var d: Int = 24
            }
            """,
            expandedSource: """
            struct Struct {
                let a: String
                let b: Int
                var c: Int
                var d: Int = 24

                func copy(a: String? = nil, b: Int? = nil, c: Int? = nil, d: Int? = nil) -> Struct {
                    Struct(a: a ?? self.a, b: b ?? self.b, c: c ?? self.c, d: d ?? self.d)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testCopyable_differentTypeInlinedProperties() throws {
        assertMacroExpansion(
            """
            @Copyable
            struct Struct {
                let a: String, b: Int
            }
            """,
            expandedSource: """
            struct Struct {
                let a: String, b: Int

                func copy(a: String? = nil, b: Int? = nil) -> Struct {
                    Struct(a: a ?? self.a, b: b ?? self.b)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testCopyable_sameTypeInlinedProperties() throws {
        assertMacroExpansion(
            """
            @Copyable
            struct Struct {
                let a, b: String
            }
            """,
            expandedSource: """
            struct Struct {
                let a, b: String

                func copy(a: String? = nil, b: String? = nil) -> Struct {
                    Struct(a: a ?? self.a, b: b ?? self.b)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testCopyable_inlinedPropertiesMix() throws {
        assertMacroExpansion(
            """
            @Copyable
            struct Struct {
                let a, b: String, c, d: Int
            }
            """,
            expandedSource: """
            struct Struct {
                let a, b: String, c, d: Int

                func copy(a: String? = nil, b: String? = nil, c: Int? = nil, d: Int? = nil) -> Struct {
                    Struct(a: a ?? self.a, b: b ?? self.b, c: c ?? self.c, d: d ?? self.d)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testCopyable_didSetAndWillSet() throws {
        assertMacroExpansion(
            """
            @Copyable
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
            """,
            expandedSource: """
            struct Struct {
                var a: Int {
                    didSet {
                        print("didSet")
                    }
                    willSet {
                        print("willSet")
                    }
                }

                func copy(a: Int? = nil) -> Struct {
                    Struct(a: a ?? self.a)
                }
            }
            """,
            macros: testMacros
        )
    }
}

#endif
