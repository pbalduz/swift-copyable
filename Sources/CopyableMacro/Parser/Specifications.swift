import SwiftSyntax

struct Specifications {
    struct Property {
        let name: TokenSyntax
        let type: TypeSyntax
    }
    let name: TokenSyntax
    let properties: [Property]
}
