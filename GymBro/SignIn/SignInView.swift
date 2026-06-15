import SwiftUI

/// Screen 06 — Sign In (returning user, pre-onboarding auth).
///
/// Reached from Onboarding → "I already have an account". Collects email and
/// password, runs a demo auth on submit, and surfaces loading / success /
/// error states on the primary CTA. Back chevron pops to the previous screen.
struct SignInView: View {
    @Environment(\.coordinator) private var coordinator

    @State private var viewModel: SignInViewModel
    @FocusState private var focusedField: SignInState.Field?

    init(viewModel: SignInViewModel = SignInViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var vm = viewModel

        VStack(spacing: 0) {
            navBar

            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.top, 18)

                fields(vm: vm)
                    .padding(.top, 28)

                forgotPassword
                    .padding(.top, 12)

                if viewModel.state.status == .error {
                    errorBanner
                        .padding(.top, 18)
                }

                primaryCTA
                    .padding(.top, viewModel.state.status == .error ? 14 : 28)

                divider
                    .padding(.vertical, 20)

                appleButton

                Spacer(minLength: 16)

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

    private var navBar: some View {
        HStack {
            Button {
                coordinator.pop()
            } label: {
                GBIconButton(icon: "chevron.left")
            }
            .buttonStyle(.plain)
            .padding(.leading, -4)

            Spacer()
        }
        .frame(height: 44)
        .padding(.horizontal, 20)
        .padding(.top, 4)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Welcome back")
                .font(.barlowCondensed(.bold, size: 28))
                .tracking(-0.6)
                .foregroundStyle(.labelPrimary)
            Text("Sign in to pick up where you left off.")
                .font(.plusJakartaSans(.regular, size: 14))
                .foregroundStyle(.labelSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
            viewModel.submit()
        }
    }

    private var forgotPassword: some View {
        HStack {
            Spacer()
            Button("Forgot password?") {}
                .font(.plusJakartaSans(.medium, size: 13))
                .foregroundStyle(.labelSecondary)
                .buttonStyle(.plain)
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

    // MARK: - Primary CTA

    private var primaryCTA: some View {
        let status = viewModel.state.status
        let isLoading = status == .loading
        let isSuccess = status == .success

        return Button {
            focusedField = nil
            viewModel.submit()
        } label: {
            HStack(spacing: 9) {
                if isLoading {
                    SignInSpinner()
                } else if isSuccess {
                    Image(systemName: "checkmark")
                        .font(.system(size: 17, weight: .bold))
                }
                Text(isLoading ? "Signing in…" : isSuccess ? "Signed in" : "Sign In")
                    .font(.plusJakartaSans(.semiBold, size: 16))
            }
            .foregroundStyle(.labelOnAccent)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(isSuccess ? Color.voltMedium : Color.volt)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .opacity(isLoading ? 0.92 : 1)
            .animation(.easeInOut(duration: 0.16), value: status)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }

    // MARK: - Divider

    private var divider: some View {
        HStack(spacing: 14) {
            Rectangle().fill(Color.borderDefault).frame(height: 1)
            Text("or")
                .font(.system(size: 11, weight: .regular, design: .monospaced))
                .tracking(1.2)
                .textCase(.uppercase)
                .foregroundStyle(.labelTertiary)
            Rectangle().fill(Color.borderDefault).frame(height: 1)
        }
    }

    // MARK: - Apple

    private var appleButton: some View {
        Button {} label: {
            HStack(spacing: 8) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 17, weight: .medium))
                Text("Sign in with Apple")
                    .font(.plusJakartaSans(.semiBold, size: 15))
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(.labelPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Bottom link

    private var bottomLink: some View {
        HStack(spacing: 6) {
            Text("Don't have an account?")
                .font(.plusJakartaSans(.regular, size: 13))
                .foregroundStyle(.labelSecondary)
            Button("Sign up") {}
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
private struct SignInSpinner: View {
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
