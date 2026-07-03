import SwiftUI

/// Icon-only nav bar used by the pre-onboarding auth screens — a single
/// leading `GBIconButton` (back chevron or close ×) and nothing else.
struct AuthNavBar: View {
    var icon: String = "chevron.left"
    var accessibilityLabel: String = "Back"
    let action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                GBIconButton(icon: icon)
            }
            .buttonStyle(.plain)
            .padding(.leading, -4)
            .accessibilityLabel(accessibilityLabel)

            Spacer()
        }
        .frame(height: 44)
        .padding(.horizontal, 20)
        .padding(.top, 4)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        AuthNavBar {}
        AuthNavBar(icon: "xmark", accessibilityLabel: "Close") {}
        Spacer()
    }
    .background(.appBackground)
}
