import SwiftUI

/// Volt-filled primary CTA shared by the auth screens, swapping its label for
/// a spinner while loading and a checkmark on success.
struct AuthPrimaryCTA: View {
    enum Phase {
        case idle
        case loading
        case success
    }

    /// How long the success phase stays on screen before the flow routes onward.
    static let successHold: Duration = .milliseconds(900)

    let title: String
    let loadingTitle: String
    var successTitle: String = ""
    let phase: Phase
    var isEnabled: Bool = true
    /// Dims the idle button when the form isn't valid yet.
    var dimmed: Bool = false
    let action: () -> Void

    private var label: String {
        switch phase {
        case .idle: title
        case .loading: loadingTitle
        case .success: successTitle
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 9) {
                if phase == .loading {
                    AuthSpinner()
                } else if phase == .success {
                    Image(systemName: "checkmark")
                        .font(.system(size: 17, weight: .bold))
                }
                Text(label)
                    .font(.plusJakartaSans(.semiBold, size: 16))
            }
            .foregroundStyle(.labelOnAccent)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(phase == .success ? Color.voltMedium : Color.volt)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .opacity(dimmed && phase == .idle ? 0.35 : (phase == .loading ? 0.92 : 1))
            .animation(.easeInOut(duration: 0.16), value: phase)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        AuthPrimaryCTA(title: "Sign In", loadingTitle: "Signing in…", phase: .idle) {}
        AuthPrimaryCTA(title: "Sign In", loadingTitle: "Signing in…", phase: .loading, isEnabled: false) {}
        AuthPrimaryCTA(
            title: "Create account & save",
            loadingTitle: "Creating account…",
            successTitle: "Plan saved",
            phase: .success
        ) {}
        AuthPrimaryCTA(
            title: "Send reset link",
            loadingTitle: "Sending…",
            phase: .idle,
            isEnabled: false,
            dimmed: true
        ) {}
    }
    .padding(24)
    .background(.appBackground)
}
