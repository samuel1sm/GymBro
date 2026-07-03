import SwiftUI

/// "By continuing you agree to the Terms and Privacy Policy." — the legal
/// links rendered secondary + underlined, the surrounding copy tertiary.
struct SignUpLegalFooter: View {
    var body: some View {
        Text(legalText)
            .font(.plusJakartaSans(.regular, size: 11))
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
    }

    private var legalText: AttributedString {
        func run(_ text: String, color: Color, underline: Bool = false) -> AttributedString {
            var run = AttributedString(text)
            run.foregroundColor = color
            if underline { run.underlineStyle = .single }
            return run
        }
        return run("By continuing you agree to the ", color: .labelTertiary)
            + run("Terms", color: .labelSecondary, underline: true)
            + run(" and ", color: .labelTertiary)
            + run("Privacy Policy", color: .labelSecondary, underline: true)
            + run(".", color: .labelTertiary)
    }
}

// MARK: - Preview

#Preview {
    SignUpLegalFooter()
        .padding(24)
        .background(.appBackground)
}
