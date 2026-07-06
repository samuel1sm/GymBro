import Foundation

/// Single home for the credential rules shared by the auth forms and the
/// (mock) account service, so they can't drift apart.
nonisolated enum AuthValidation {

    static let minPasswordLength = 8

    /// Loose shape check (`x@y.z`) — real validation belongs to the backend.
    static func isValidEmail(_ email: String) -> Bool {
        email.trimmingCharacters(in: .whitespaces).range(
            of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#,
            options: .regularExpression
        ) != nil
    }
}
