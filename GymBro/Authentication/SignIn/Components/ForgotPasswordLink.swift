import SwiftUI

/// Right-aligned "Forgot password?" link under the password field.
struct ForgotPasswordLink: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button("Forgot password?", action: action)
                .font(.plusJakartaSans(.medium, size: 13))
                .foregroundStyle(.labelSecondary)
                .buttonStyle(.plain)
        }
    }
}

// MARK: - Preview

#Preview {
    ForgotPasswordLink {}
        .padding(24)
        .background(.appBackground)
}
