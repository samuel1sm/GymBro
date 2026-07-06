import Foundation

/// Screen 06 — Sign In (returning user, pre-onboarding auth layer).
///
/// Reached from Onboarding → "I already have an account", or on an expired
/// session. Holds the email/password the user types plus the transient auth
/// status driving the CTA (idle → loading → success / error).
struct SignInState {

    /// Auth lifecycle. Drives the primary CTA appearance.
    enum Status {
        case idle
        case loading
        case error
        case success
    }

    /// Which text field is being edited — drives the Volt-tinted focus border.
    enum Field: Hashable {
        case email
        case password
    }

    var email: String = ""
    var password: String = ""
    var revealPassword: Bool = false
    var status: Status = .idle
    var errorMessage: String = ""

    // MARK: - Derived

    /// Both fields carry something — the bare minimum to attempt a sign-in.
    var hasBothFields: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty
    }
}
