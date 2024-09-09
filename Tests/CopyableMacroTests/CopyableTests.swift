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

    func testCopyableWithPropertiesOnTheSameLine() throws {
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
}

#endif
