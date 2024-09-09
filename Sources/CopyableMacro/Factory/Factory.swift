import SwiftSyntax

protocol Factory {
    associatedtype Result: SyntaxProtocol

    static func build(with specifications: Specifications) throws -> Result
}
