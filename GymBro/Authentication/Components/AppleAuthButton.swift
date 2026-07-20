import SwiftUI

/// White "Sign in/up with Apple" button; the owning screen supplies the auth action.
struct AppleAuthButton: View {
    let title: String
    var height: CGFloat = 54
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 17, weight: .medium))
                Text(title)
                    .font(.plusJakartaSans(.semiBold, size: 15))
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(.labelPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        AppleAuthButton(title: "Sign in with Apple")
        AppleAuthButton(title: "Sign up with Apple", height: 52)
    }
    .padding(24)
    .background(.appBackground)
}
