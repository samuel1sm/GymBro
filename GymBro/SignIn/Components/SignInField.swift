import SwiftUI

private extension Color {
    static let voltFocusBorder = Color(red: 58 / 255, green: 74 / 255, blue: 0)
}

struct SignInField<Content: View>: View {
    let label: LocalizedStringKey
    let isFocused: Bool
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .tracking(1.4)
                .textCase(.uppercase)
                .foregroundStyle(.labelTertiary)

            HStack(spacing: 8) {
                content()
            }
            .frame(height: 52)
            .padding(.horizontal, 14)
            .background(.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? Color.voltFocusBorder : Color.borderDefault,
                        lineWidth: 1.5
                    )
            )
            .animation(.easeInOut(duration: 0.14), value: isFocused)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        SignInField(label: "Email", isFocused: false) {
            Text("you@email.com")
            Spacer()
        }
        SignInField(label: "Password", isFocused: true) {
            Text("••••••••").foregroundStyle(.labelPrimary)
            Spacer()
            Image(systemName: "eye").foregroundStyle(.labelSecondary)
        }
    }
    .padding(24)
    .background(.appBackground)
}
