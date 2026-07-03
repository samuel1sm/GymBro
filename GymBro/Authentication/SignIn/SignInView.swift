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

    /// The account already has a plan saved in SwiftData.
    private func hasPersistedPlan() -> Bool {
        guard let user = try? userStore.loadUser() else { return false }
        return ((try? userStore.loadSavedPlans(for: user)) ?? []).isEmpty == false
    }

    private func submit() {
        // Without a persisted plan the user still has to review (and save)
        // one — pending or freshly generated; otherwise go straight to Home.
        let destination: Route = hasPersistedPlan() ? .main : .plannerReview
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

    /// Styled placeholder. Uses `verbatim:` so an email-shaped string isn't
    /// parsed as markdown and auto-linkified into an accent-tinted link —
    /// keeping the placeholder the design's tertiary gray.
    private func placeholder(_ text: String) -> Text {
        Text(verbatim: text).foregroundStyle(.labelTertiary)
    }

    private func fields(vm: SignInViewModel) -> some View {
        @Bindable var vm = vm
        return VStack(spacing: 16) {
            SignInField(label: "Email", isFocused: focusedField == .email) {
                TextField("", text: $vm.state.email, prompt: placeholder("you@email.com"))
                    .font(.plusJakartaSans(.regular, size: 15))
                    .foregroundStyle(.labelPrimary)
                    .tint(.volt)
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
            }

            SignInField(label: "Password", isFocused: focusedField == .password) {
                passwordInput(vm: vm)

                Button {
                    viewModel.toggleReveal()
                } label: {
                    Image(systemName: viewModel.state.revealPassword ? "eye" : "eye.slash")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.labelSecondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(viewModel.state.revealPassword ? "Hide password" : "Show password")
            }
        }
    }

    private func passwordInput(vm: SignInViewModel) -> some View {
        @Bindable var vm = vm
        return Group {
            if viewModel.state.revealPassword {
                TextField("", text: $vm.state.password, prompt: placeholder("••••••••"))
                    .tracking(-0.1)
            } else {
                SecureField("", text: $vm.state.password, prompt: placeholder("••••••••"))
                    .tracking(2)
            }
        }
        .font(.plusJakartaSans(.regular, size: 15))
        .foregroundStyle(.labelPrimary)
        .tint(.volt)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .focused($focusedField, equals: .password)
        .submitLabel(.go)
        .onSubmit {
            focusedField = nil
            submit()
        }
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
