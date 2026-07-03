import SwiftUI

struct SignUpView: View {
    @Environment(\.coordinator) private var coordinator
    @Environment(\.accountService) private var accountService
    @Environment(\.userStore) private var userStore
    @Environment(\.pendingPlanStore) private var pendingPlanStore

    @State private var viewModel: SignUpViewModel
    @FocusState private var focusedField: SignUpState.Field?

    init(viewModel: SignUpViewModel = SignUpViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    private func submit() {
        // A pending plan means a fresh signup out of plan generation — that
        // flow reviews (and saves) the plan first; otherwise go straight to Home.
        let isNewUser = pendingPlanStore.hasPendingPlan
        viewModel.submit(
            accountService: accountService,
            userStore: userStore,
            pendingPlan: pendingPlanStore,
            onSuccess: { coordinator.replaceRoot(isNewUser ? .plannerReview : .main) }
        )
    }

    var body: some View {
        @Bindable var vm = viewModel

        VStack(spacing: 0) {
            // Close (×) only — no title. This is a modal gate, not a nav step.
            AuthNavBar(icon: "xmark", accessibilityLabel: "Close") {
                focusedField = nil
                coordinator.pop()
            }

            VStack(alignment: .leading, spacing: 0) {
                PendingPlanChip(planTitle: viewModel.state.planTitle)
                    .padding(.top, 14)

                AuthHeader(
                    title: "Save your plan",
                    subtitle: "Create a free account so your plan, progress, and records sync across sessions.",
                    titleSize: 25,
                    subtitleTracking: -0.1
                )
                .padding(.top, 20)

                // Apple is the primary path, placed first.
                AppleAuthButton(title: "Sign up with Apple", height: 52)
                    .padding(.top, 22)

                AuthDivider(text: "or with email")
                    .padding(.vertical, 18)

                fields(vm: vm)

                if viewModel.state.status == .error {
                    AuthErrorBanner(message: viewModel.state.errorMessage)
                        .padding(.top, 18)
                }

                primaryCTA
                    .padding(.top, viewModel.state.status == .error ? 14 : 22)

                SignUpLegalFooter()
                    .padding(.top, 14)

                Spacer(minLength: 12)

                AuthBottomLink(prompt: "Already have an account?", actionTitle: "Sign in") {
                    focusedField = nil
                    coordinator.push(.accountInformation)
                }
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
    /// parsed as markdown and auto-linkified — keeping the placeholder the
    /// design's tertiary gray.
    private func placeholder(_ text: String) -> Text {
        Text(verbatim: text).foregroundStyle(.labelTertiary)
    }

    private func fields(vm: SignUpViewModel) -> some View {
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

    private func passwordInput(vm: SignUpViewModel) -> some View {
        @Bindable var vm = vm
        return Group {
            if viewModel.state.revealPassword {
                TextField("", text: $vm.state.password, prompt: placeholder("At least 8 characters"))
                    .tracking(-0.1)
            } else {
                SecureField("", text: $vm.state.password, prompt: placeholder("At least 8 characters"))
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

    // MARK: - Primary CTA — Create account & save

    private var primaryCTA: some View {
        let status = viewModel.state.status
        let phase: AuthPrimaryCTA.Phase = switch status {
        case .loading: .loading
        case .success: .success
        case .idle, .error: .idle
        }

        return AuthPrimaryCTA(
            title: "Create account & save",
            loadingTitle: "Creating account…",
            successTitle: "Plan saved",
            phase: phase,
            isEnabled: viewModel.state.canSubmit(),
            dimmed: !viewModel.state.emailIsValid || !viewModel.state.passwordIsValid
        ) {
            focusedField = nil
            submit()
        }
    }
}

// MARK: - Preview

#Preview("Interactive") {
    RouterView { SignUpView() }
}

#Preview("Valid — CTA enabled") {
    RouterView {
        SignUpView(
            viewModel: SignUpViewModel(
                state: SignUpState(email: "alex@gymbro.app", password: "strongpass")
            )
        )
    }
}

#Preview("Loading") {
    RouterView {
        SignUpView(
            viewModel: SignUpViewModel(
                state: SignUpState(email: "alex@gymbro.app", password: "strongpass", status: .loading)
            )
        )
    }
}

#Preview("Error — duplicate email") {
    RouterView {
        SignUpView(
            viewModel: SignUpViewModel(
                state: SignUpState(
                    email: "alex@gymbro.app",
                    password: "strongpass",
                    status: .error,
                    errorMessage: "That email is already registered. Try signing in."
                )
            )
        )
    }
}
