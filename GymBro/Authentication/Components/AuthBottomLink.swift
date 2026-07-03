import SwiftUI

/// Footer prompt + volt link swapping between the auth screens
/// ("Don't have an account? Sign up", "Remembered it? Back to sign in"…).
struct AuthBottomLink: View {
    let prompt: String
    let actionTitle: String
    var action: () -> Void = {}

    var body: some View {
        HStack(spacing: 6) {
            Text(prompt)
                .font(.plusJakartaSans(.regular, size: 13))
                .foregroundStyle(.labelSecondary)
            Button(actionTitle, action: action)
                .font(.plusJakartaSans(.semiBold, size: 13))
                .foregroundStyle(.volt)
                .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        AuthBottomLink(prompt: "Don't have an account?", actionTitle: "Sign up")
        AuthBottomLink(prompt: "Already have an account?", actionTitle: "Sign in")
        AuthBottomLink(prompt: "Remembered it?", actionTitle: "Back to sign in")
    }
    .padding(24)
    .background(.appBackground)
}
