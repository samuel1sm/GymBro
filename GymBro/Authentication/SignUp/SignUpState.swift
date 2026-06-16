import Foundation

/// Sign Up — Save Plan Gate.
///
/// Presented modally the first time an anonymous user tries to save their
/// generated plan or start a workout (from Planner Review / start-workout).
/// Collects an email + password (or the Apple path) so the anonymous profile
/// and plan can migrate to a real account. Holds the form input plus the
/// transient account-creation status driving the primary CTA.
struct SignUpState {

    /// Account-creation lifecycle. Drives the primary CTA appearance.
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

    /// Plan being saved — shown in the loss-aversion chip at the top.
    var planTitle: String = "Push Day · 5 training days"

    var email: String = ""
    var password: String = ""
    var revealPassword: Bool = false
    var status: Status = .idle
    var errorMessage: String = ""

    // MARK: - Derived

    /// Email is well-formed.
    var emailIsValid: Bool {
        email.range(of: #"^\S+@\S+\.\S+$"#, options: .regularExpression) != nil
    }

    /// Password meets the minimum length the design enforces.
    var passwordIsValid: Bool {
        password.count >= 8
    }

    /// The CTA only enables once both fields pass — and never mid-request or
    /// after a successful create. Mirrors `canSubmit` in the prototype.
    func canSubmit() -> Bool {
        emailIsValid && passwordIsValid && status != .loading && status != .success
    }
}
