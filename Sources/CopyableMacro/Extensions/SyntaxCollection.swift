import SwiftSyntax

extension SyntaxCollection where Element: WithTrailingCommaSyntax {
    var trimmingLastTrailingComma: Self {
        guard
            let last = last,
            let index = index(of: last)
        else { return self }
        let newLast = last.with(\.trailingComma, nil)
        return self.with(\.[index], newLast)
    }
}
