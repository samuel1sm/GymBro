import SwiftUI

/// "── or ──" separator between the email form and the Apple button.
struct AuthDivider: View {
    var text: String = "or"

    var body: some View {
        HStack(spacing: 14) {
            Rectangle().fill(Color.borderDefault).frame(height: 1)
            Text(text)
                .font(.system(size: 11, weight: .regular, design: .monospaced))
                .tracking(1.2)
                .textCase(.uppercase)
                .foregroundStyle(.labelTertiary)
            Rectangle().fill(Color.borderDefault).frame(height: 1)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 24) {
        AuthDivider()
        AuthDivider(text: "or with email")
    }
    .padding(24)
    .background(.appBackground)
}
