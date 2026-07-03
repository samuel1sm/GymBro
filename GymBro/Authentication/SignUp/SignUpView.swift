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
            navBar

            VStack(alignment: .leading, spacing: 0) {
                planChip
                    .padding(.top, 14)

                header
                    .padding(.top, 20)

                appleButton
                    .padding(.top, 22)

                divider
                    .padding(.vertical, 18)

                fields(vm: vm)

                if viewModel.state.status == .error {
                    errorBanner
                        .padding(.top, 18)
                }

                primaryCTA
                    .padding(.top, viewModel.state.status == .error ? 14 : 22)

                legal
                    .padding(.top, 14)

                Spacer(minLength: 12)

                bottomLink
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

    // MARK: - Nav bar

    /// Close (×) only — no title. This is a modal gate, not a nav step.
    private var navBar: some View {
        HStack {
            Button {
                focusedField = nil
                coordinator.pop()
            } label: {
                GBIconButton(icon: "xmark")
            }
            .buttonStyle(.plain)
            .padding(.leading, -4)
            .accessibilityLabel("Close")

            Spacer()
        }
        .frame(height: 44)
        .padding(.horizontal, 20)
        .padding(.top, 4)
    }

    // MARK: - Plan chip

    private var planChip: some View {
        HStack(spacing: 12) {
            ClipboardCheckIcon(size: 20, color: .volt)
                .frame(width: 40, height: 40)
                .background(.planTileBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.volt, lineWidth: 1))

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.state.planTitle)
                    .font(.plusJakartaSans(.semiBold, size: 13))
                    .tracking(-0.1)
                    .foregroundStyle(.labelPrimary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text("Your plan is ready — create an account to keep it")
                    .font(.plusJakartaSans(.regular, size: 11))
                    .foregroundStyle(.labelSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.planChipBorder, lineWidth: 1))
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Save your plan")
                .font(.barlowCondensed(.bold, size: 25))
                .tracking(-0.6)
                .foregroundStyle(.labelPrimary)
            Text("Create a free account so your plan, progress, and records sync across sessions.")
                .font(.plusJakartaSans(.regular, size: 14))
                .tracking(-0.1)
                .foregroundStyle(.labelSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Apple — primary path, placed first

    private var appleButton: some View {
        Button {} label: {
            HStack(spacing: 8) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 17, weight: .medium))
                Text("Sign up with Apple")
                    .font(.plusJakartaSans(.semiBold, size: 15))
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(.labelPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Divider

    private var divider: some View {
        HStack(spacing: 14) {
            Rectangle().fill(Color.borderDefault).frame(height: 1)
            Text("or with email")
                .font(.system(size: 11, weight: .regular, design: .monospaced))
                .tracking(1.2)
                .textCase(.uppercase)
                .foregroundStyle(.labelTertiary)
            Rectangle().fill(Color.borderDefault).frame(height: 1)
        }
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

    // MARK: - Error banner

    private var errorBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "xmark")
                .font(.system(size: 9, weight: .heavy))
                .foregroundStyle(.appBackground)
                .frame(width: 16, height: 16)
                .background(.danger)
                .clipShape(Circle())

            Text(viewModel.state.errorMessage)
                .font(.plusJakartaSans(.regular, size: 13))
                .foregroundStyle(.danger)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Primary CTA — Create account & save

    private var primaryCTA: some View {
        let status = viewModel.state.status
        let isLoading = status == .loading
        let isSuccess = status == .success
        let canSubmit = viewModel.state.canSubmit()
        let dimmed = !viewModel.state.emailIsValid || !viewModel.state.passwordIsValid

        return Button {
            focusedField = nil
            submit()
        } label: {
            HStack(spacing: 9) {
                if isLoading {
                    SignUpSpinner()
                } else if isSuccess {
                    Image(systemName: "checkmark")
                        .font(.system(size: 17, weight: .bold))
                }
                Text(isLoading ? "Creating account…" : isSuccess ? "Plan saved" : "Create account & save")
                    .font(.plusJakartaSans(.semiBold, size: 16))
            }
            .foregroundStyle(.labelOnAccent)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(isSuccess ? Color.voltMedium : Color.volt)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .opacity(dimmed && !isLoading && !isSuccess ? 0.35 : (isLoading ? 0.92 : 1))
            .animation(.easeInOut(duration: 0.16), value: status)
        }
        .buttonStyle(.plain)
        .disabled(!canSubmit)
    }

    // MARK: - Legal

    private var legal: some View {
        Text(legalText)
            .font(.plusJakartaSans(.regular, size: 11))
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
    }

    /// "By continuing you agree to the Terms and Privacy Policy." — the legal
    /// links rendered secondary + underlined, the surrounding copy tertiary.
    private var legalText: AttributedString {
        func run(_ text: String, color: Color, underline: Bool = false) -> AttributedString {
            var run = AttributedString(text)
            run.foregroundColor = color
            if underline { run.underlineStyle = .single }
            return run
        }
        return run("By continuing you agree to the ", color: .labelTertiary)
            + run("Terms", color: .labelSecondary, underline: true)
            + run(" and ", color: .labelTertiary)
            + run("Privacy Policy", color: .labelSecondary, underline: true)
            + run(".", color: .labelTertiary)
    }

    // MARK: - Bottom link

    private var bottomLink: some View {
        HStack(spacing: 6) {
            Text("Already have an account?")
                .font(.plusJakartaSans(.regular, size: 13))
                .foregroundStyle(.labelSecondary)
            Button("Sign in") {
                focusedField = nil
                coordinator.push(.accountInformation)
            }
                .font(.plusJakartaSans(.semiBold, size: 13))
                .foregroundStyle(.volt)
                .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Spinner

/// 18pt ring with a transparent top, spinning continuously — matches the
/// prototype's loading indicator on the CTA.
private struct SignUpSpinner: View {
    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(Color.labelOnAccent, style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .frame(width: 18, height: 18)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 0.72).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
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
