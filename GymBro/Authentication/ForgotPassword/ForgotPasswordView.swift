import SwiftUI

/// Screen 07 — Forgot Password (account recovery, pre-onboarding auth).
///
/// Reached from Sign In → "Forgot password?". Collects the account email and
/// "sends" a reset link, then swaps to a confirmation. Back chevron and both
/// "Back to sign in" actions pop to the previous screen.
struct ForgotPasswordView: View {
    @Environment(\.coordinator) private var coordinator

    @State private var viewModel: ForgotPasswordViewModel
    @FocusState private var focusedField: ForgotPasswordState.Field?

    init(viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var vm = viewModel

        VStack(spacing: 0) {
            AuthNavBar { coordinator.pop() }

            Group {
                if viewModel.state.sent {
                    ResetLinkConfirmation(sentTo: viewModel.state.sentToDisplay) {
                        coordinator.pop()
                    }
                } else {
                    entry(vm: vm)
                }
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appBackground)
        .contentShape(Rectangle())
        .onTapGesture { focusedField = nil }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - State A — Email entry

    private func entry(vm: ForgotPasswordViewModel) -> some View {
        @Bindable var vm = vm
        return VStack(alignment: .leading, spacing: 0) {
            AuthHeader(
                title: "Reset password",
                subtitle: "Enter the email tied to your account and we'll send a reset link."
            )
            .padding(.top, 18)

            SignInField(label: "Email", isFocused: focusedField == .email) {
                TextField("", text: $vm.state.email, prompt: placeholder("you@email.com"))
                    .font(.plusJakartaSans(.regular, size: 15))
                    .foregroundStyle(.labelPrimary)
                    .tint(.volt)
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.go)
                    .onSubmit {
                        focusedField = nil
                        viewModel.submit()
                    }
            }
            .padding(.top, 28)

            primaryCTA
                .padding(.top, 24)

            Spacer(minLength: 16)

            AuthBottomLink(prompt: "Remembered it?", actionTitle: "Back to sign in") {
                coordinator.pop()
            }
            .padding(.bottom, 8)
        }
    }

    /// Styled placeholder. Uses `verbatim:` so an email-shaped string isn't
    /// parsed as markdown and auto-linkified — keeping it the design's
    /// tertiary gray.
    private func placeholder(_ text: String) -> Text {
        Text(verbatim: text).foregroundStyle(.labelTertiary)
    }

    private var primaryCTA: some View {
        let valid = viewModel.state.emailIsValid
        let isLoading = viewModel.state.status == .loading

        return AuthPrimaryCTA(
            title: "Send reset link",
            loadingTitle: "Sending…",
            phase: isLoading ? .loading : .idle,
            isEnabled: valid && !isLoading,
            dimmed: !valid
        ) {
            focusedField = nil
            viewModel.submit()
        }
    }
}

// MARK: - Preview

#Preview("Interactive") {
    RouterView { ForgotPasswordView() }
}

#Preview("Valid — CTA enabled") {
    RouterView {
        ForgotPasswordView(
            viewModel: ForgotPasswordViewModel(
                state: ForgotPasswordState(email: "alex@gymbro.app")
            )
        )
    }
}

#Preview("Loading") {
    RouterView {
        ForgotPasswordView(
            viewModel: ForgotPasswordViewModel(
                state: ForgotPasswordState(email: "alex@gymbro.app", status: .loading)
            )
        )
    }
}

#Preview("Confirmation") {
    RouterView {
        ForgotPasswordView(
            viewModel: ForgotPasswordViewModel(
                state: ForgotPasswordState(email: "alex@gymbro.app", sent: true)
            )
        )
    }
}
