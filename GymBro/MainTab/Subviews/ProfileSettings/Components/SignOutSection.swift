import SwiftUI

/// Account footer — the "Sign Out" button and its caption.
struct SignOutSection: View {
    let onSignOut: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: onSignOut) {
                Text("Sign Out")
                    .font(.plusJakartaSans(.semiBold, size: 15))
                    .foregroundStyle(.danger)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderDefault, lineWidth: 1))
            }
            .buttonStyle(.plain)

            Text("Signs you out on this device. Your plans and workout history stay saved.")
                .font(.plusJakartaSans(.regular, size: 12))
                .foregroundStyle(.labelTertiary)
                .lineSpacing(3)
                .padding(.horizontal, 4)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 28)
    }
}

// MARK: - Preview

#Preview {
    SignOutSection {}
        .background(.appBackground)
}
