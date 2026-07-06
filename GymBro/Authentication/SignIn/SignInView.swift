import SwiftUI

/// Screen 06 — Sign In (returning user, pre-onboarding auth).
///
/// Reached from Onboarding → "I already have an account". Collects email and
/// password, runs a demo auth on submit, and surfaces loading / success /
/// error states on the primary CTA. Back chevron pops to the previous screen.
struct SignInView: View {
    @Environment(\.coordinator) private var coordinator
    @Environment(\.accountService) private var accountService
    @Environment(\.userStore) private var userStore

    @State private var viewModel: SignInViewModel
    @FocusState private var focusedField: SignInState.Field?

    init(viewModel: SignInViewModel = SignInViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    private func submit() {
        let destination = LoginFlow.postSignInRoute(using: userStore)
        viewModel.submit(
            accountService: accountService,
            onSuccess: { coordinator.replaceRoot(destination) }
        )
    }

    var body: some View {
        @Bindable var vm = viewModel

        VStack(spacing: 0) {
            AuthNavBar { coordinator.pop() }

            VStack(alignment: .leading, spacing: 0) {
                AuthHeader(
                    title: "Welcome back",
                    subtitle: "Sign in to pick up where you left off."
                )
                .padding(.top, 18)

                fields(vm: vm)
                    .padding(.top, 28)

                ForgotPasswordLink {
                    focusedField = nil
                    coordinator.push(.forgotPassword)
                }
                .padding(.top, 12)

                if viewModel.state.status == .error {
                    AuthErrorBanner(message: viewModel.state.errorMessage)
                        .padding(.top, 18)
                }

                primaryCTA
                    .padding(.top, viewModel.state.status == .error ? 14 : 28)

                AuthDivider()
                    .padding(.vertical, 20)

                AppleAuthButton(title: "Sign in with Apple")

                Spacer(minLength: 16)

                AuthBottomLink(prompt: "Don't have an account?", actionTitle: "Sign up")
                    .padding(.bottom, 8)
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.appBackground)
        .contentShape(Rectangle())
        .onTapGesture { focusedField = nil }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Fields

    private func fields(vm: SignInViewModel) -> some View {
        @Bindable var vm = vm
        return AuthCredentialFields(
            email: $vm.state.email,
            password: $vm.state.password,
            revealPassword: $vm.state.revealPassword,
            focus: $focusedField,
            emailField: .email,
            passwordField: .password,
            onSubmit: {
                focusedField = nil
                submit()
            }
        )
    }

    // MARK: - Primary CTA

    private var primaryCTA: some View {
        let status = viewModel.state.status
        let phase: AuthPrimaryCTA.Phase = switch status {
        case .loading: .loading
        case .success: .success
        case .idle, .error: .idle
        }

        return AuthPrimaryCTA(
            title: "Sign In",
            loadingTitle: "Signing in…",
            successTitle: "Signed in",
            phase: phase,
            isEnabled: status != .loading
        ) {
            focusedField = nil
            submit()
        }
    }
}

// MARK: - Preview

#Preview("Interactive") {
    RouterView { SignInView() }
}

#Preview("Error") {
    RouterView {
        SignInView(
            viewModel: SignInViewModel(
                state: SignInState(
                    email: "alex@gymbro.app",
                    password: "nope",
                    status: .error,
                    errorMessage: "Incorrect email or password."
                )
            )
        )
    }
}

#Preview("Loading") {
    RouterView {
        SignInView(
            viewModel: SignInViewModel(
                state: SignInState(email: "alex@gymbro.app", password: "letmein", status: .loading)
            )
        )
    }
}
