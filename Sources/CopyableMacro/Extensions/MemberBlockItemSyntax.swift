import SwiftSyntax

extension MemberBlockItemSyntax {
    var variables: PatternBindingListSyntax? {
        decl.as(VariableDeclSyntax.self)?.bindings
    }
}
