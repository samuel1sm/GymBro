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
            navBar

            Group {
                if viewModel.state.sent {
                    confirmation
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

    // MARK: - State A — Email entry

    private func entry(vm: ForgotPasswordViewModel) -> some View {
        @Bindable var vm = vm
        return VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Reset password")
                    .font(.barlowCondensed(.bold, size: 28))
                    .tracking(-0.6)
                    .foregroundStyle(.labelPrimary)
                Text("Enter the email tied to your account and we'll send a reset link.")
                    .font(.plusJakartaSans(.regular, size: 14))
                    .foregroundStyle(.labelSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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

            bottomLink
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

        return Button {
            focusedField = nil
            viewModel.submit()
        } label: {
            HStack(spacing: 9) {
                if isLoading {
                    ForgotSpinner()
                }
                Text(isLoading ? "Sending…" : "Send reset link")
                    .font(.plusJakartaSans(.semiBold, size: 16))
            }
            .foregroundStyle(.labelOnAccent)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(.volt)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .opacity(valid ? (isLoading ? 0.92 : 1) : 0.35)
            .animation(.easeInOut(duration: 0.16), value: viewModel.state.status)
        }
        .buttonStyle(.plain)
        .disabled(!valid || isLoading)
    }

    private var bottomLink: some View {
        HStack(spacing: 6) {
            Text("Remembered it?")
                .font(.plusJakartaSans(.regular, size: 13))
                .foregroundStyle(.labelSecondary)
            Button("Back to sign in") {
                coordinator.pop()
            }
            .font(.plusJakartaSans(.semiBold, size: 13))
            .foregroundStyle(.volt)
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - State B — Confirmation

    private var confirmation: some View {
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
                Text(verbatim: viewModel.state.sentToDisplay)
                    .font(.plusJakartaSans(.semiBold, size: 14))
                    .foregroundStyle(.labelPrimary)
                    .monospacedDigit()
            }
            .multilineTextAlignment(.center)
            .padding(.top, 10)
            .frame(maxWidth: 280)

            Button {
                coordinator.pop()
            } label: {
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

// MARK: - Spinner

/// 18pt ring with a transparent top, spinning continuously — matches the
/// prototype's loading indicator on the CTA.
private struct ForgotSpinner: View {
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

// MARK: - Local color

private extension Color {
    /// VoltDim badge fill behind the mail-check glyph (#141A00).
    static let voltDimBadge = Color(red: 20 / 255, green: 26 / 255, blue: 0)
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
