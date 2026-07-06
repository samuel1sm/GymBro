import SwiftUI

/// Email + password pair shared by Sign In and Sign Up: styled inputs, focus
/// borders, the reveal-password toggle, and next/go submit chaining. Generic
/// over the screen's focus enum so each form keeps its own `Field` type.
struct AuthCredentialFields<Field: Hashable>: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var revealPassword: Bool

    let focus: FocusState<Field?>.Binding
    let emailField: Field
    let passwordField: Field

    var passwordPrompt: String = "••••••••"
    var onSubmit: () -> Void = {}

    var body: some View {
        VStack(spacing: 16) {
            SignInField(label: "Email", isFocused: focus.wrappedValue == emailField) {
                TextField("", text: $email, prompt: placeholder("you@email.com"))
                    .font(.plusJakartaSans(.regular, size: 15))
                    .foregroundStyle(.labelPrimary)
                    .tint(.volt)
                    .focused(focus, equals: emailField)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
                    .onSubmit { focus.wrappedValue = passwordField }
            }

            SignInField(label: "Password", isFocused: focus.wrappedValue == passwordField) {
                passwordInput

                Button {
                    revealPassword.toggle()
                } label: {
                    Image(systemName: revealPassword ? "eye" : "eye.slash")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.labelSecondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(revealPassword ? "Hide password" : "Show password")
            }
        }
    }

    /// Styled placeholder. Uses `verbatim:` so an email-shaped string isn't
    /// parsed as markdown and auto-linkified into an accent-tinted link —
    /// keeping the placeholder the design's tertiary gray.
    private func placeholder(_ text: String) -> Text {
        Text(verbatim: text).foregroundStyle(.labelTertiary)
    }

    private var passwordInput: some View {
        Group {
            if revealPassword {
                TextField("", text: $password, prompt: placeholder(passwordPrompt))
                    .tracking(-0.1)
            } else {
                SecureField("", text: $password, prompt: placeholder(passwordPrompt))
                    .tracking(2)
            }
        }
        .font(.plusJakartaSans(.regular, size: 15))
        .foregroundStyle(.labelPrimary)
        .tint(.volt)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .focused(focus, equals: passwordField)
        .submitLabel(.go)
        .onSubmit(onSubmit)
    }
}
