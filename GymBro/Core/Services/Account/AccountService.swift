import Foundation

enum AccountError: LocalizedError {
    case emailAlreadyRegistered
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .emailAlreadyRegistered:
            return String(localized: "That email is already registered. Try signing in.")
        case .invalidCredentials:
            return String(localized: "Incorrect email or password.")
        }
    }
}

/// `nonisolated` opts the service layer out of the target's default MainActor
/// isolation — auth is async backend work, not UI state.
nonisolated protocol AccountService: Sendable {
    func createAccount(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func signInWithApple(idToken: String, nonce: String) async throws
    /// Whether a previously signed-in session survives on this device, letting
    /// launch skip the auth screens.
    func hasRestorableSession() async -> Bool
    /// Ends the session on this device. Never fails from the caller's view —
    /// local data stays and the next launch simply lands on Sign In.
    func signOut() async
}
