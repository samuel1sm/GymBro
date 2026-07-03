import SwiftUI

/// Forgot Password state B — mail-check badge, "Check your inbox" copy with
/// the address the reset link went to, and a bordered back-to-sign-in button.
struct ResetLinkConfirmation: View {
    let sentTo: String
    let onBackToSignIn: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.voltDimBadge)
                Circle()
                    .stroke(Color.volt, lineWidth: 1.5)
                MailCheckIcon(size: 32, color: .volt)
            }
            .frame(width: 72, height: 72)

            Text("Check your inbox")
                .font(.barlowCondensed(.bold, size: 24))
                .tracking(-0.5)
                .foregroundStyle(.labelPrimary)
                .padding(.top, 24)

            VStack(spacing: 4) {
                Text("We sent a reset link to")
                    .font(.plusJakartaSans(.regular, size: 14))
                    .foregroundStyle(.labelSecondary)
                Text(verbatim: sentTo)
                    .font(.plusJakartaSans(.semiBold, size: 14))
                    .foregroundStyle(.labelPrimary)
                    .monospacedDigit()
            }
            .multilineTextAlignment(.center)
            .padding(.top, 10)
            .frame(maxWidth: 280)

            Button(action: onBackToSignIn) {
                Text("Back to sign in")
                    .font(.plusJakartaSans(.semiBold, size: 16))
                    .foregroundStyle(.labelPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.borderDefault, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            .padding(.top, 32)

            Spacer()
        }
        .padding(.bottom, 48)
    }
}

// MARK: - Local color

private extension Color {
    /// VoltDim badge fill behind the mail-check glyph (#141A00).
    static let voltDimBadge = Color(red: 20 / 255, green: 26 / 255, blue: 0)
}

// MARK: - Preview

#Preview {
    ResetLinkConfirmation(sentTo: "alex@gymbro.app") {}
        .padding(.horizontal, 24)
        .background(.appBackground)
}
