import SwiftUI

/// Inline auth failure message — danger-red × badge plus the error copy.
struct AuthErrorBanner: View {
    let message: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "xmark")
                .font(.system(size: 9, weight: .heavy))
                .foregroundStyle(.appBackground)
                .frame(width: 16, height: 16)
                .background(.danger)
                .clipShape(Circle())

            Text(message)
                .font(.plusJakartaSans(.regular, size: 13))
                .foregroundStyle(.danger)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview {
    AuthErrorBanner(message: "Incorrect email or password.")
        .padding(24)
        .background(.appBackground)
}
