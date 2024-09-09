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
            struct Player {
                let name: String
                let number: Int
            }
            """,
            expandedSource: """
            struct Player {
                let name: String
                let number: Int

                func copy(name: String? = nil, number: Int? = nil) -> Player {
                    Player(name: name ?? self.name, number: number ?? self.number)
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
            struct Player {
                let name: String, number: Int
            }
            """,
            expandedSource: """
            struct Player {
                let name: String, number: Int

                func copy(name: String? = nil, number: Int? = nil) -> Player {
                    Player(name: name ?? self.name, number: number ?? self.number)
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
            struct Player {
                let firstName, lastName: String
            }
            """,
            expandedSource: """
            struct Player {
                let firstName, lastName: String

                func copy(firstName: String? = nil, lastName: Int? = nil) -> Player {
                    Player(firstName: firstName ?? self.firstName, lastName: lastName ?? self.lastName)
                }
            }
            """,
            macros: testMacros
        )
    }
}

#endif
