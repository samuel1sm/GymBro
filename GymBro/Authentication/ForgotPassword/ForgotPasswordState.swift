import Foundation

/// Screen 07 — Forgot Password (account recovery, pre-onboarding auth layer).
///
/// Reached from Sign In → "Forgot password?". Holds the email the user types
/// plus the two mutually exclusive states the screen toggles between:
/// (A) email entry and (B) the confirmation shown after the reset link is
/// "sent". `status` drives the primary CTA (idle → loading).
struct ForgotPasswordState {

    /// Request lifecycle for the "send reset link" action.
    enum Status {
        case idle
        case loading
    }

    /// The only editable field — drives the Volt-tinted focus border.
    enum Field: Hashable {
        case email
    }

    var email: String = ""
    var status: Status = .idle
    /// `true` once the reset link has been "sent" — flips to the confirmation.
    var sent: Bool = false

    // MARK: - Derived

    /// A well-formed email enables the primary CTA (mirrors the prototype's
    /// `^[^\s@]+@[^\s@]+\.[^\s@]+$`).
    var emailIsValid: Bool {
        email.trimmingCharacters(in: .whitespaces).range(
            of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#,
            options: .regularExpression
        ) != nil
    }

    /// Address echoed back on the confirmation screen, with a fallback for the
    /// empty case so the layout never collapses.
    var sentToDisplay: String {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        return trimmed.isEmpty ? "you@email.com" : trimmed
    }
}
