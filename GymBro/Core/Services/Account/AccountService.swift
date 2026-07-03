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

protocol AccountService: Sendable {
    func createAccount(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
}

/// Demo rules until a real backend exists: creating with an email containing
/// "taken" fails as a duplicate; signing in accepts any well-formed email with
/// a 6+ character password.
struct MockAccountService: AccountService {

    func createAccount(email: String, password: String) async throws {
        try await Task.sleep(for: .milliseconds(1500))
        if email.range(of: "taken", options: .caseInsensitive) != nil {
            throw AccountError.emailAlreadyRegistered
        }
    }

    func signIn(email: String, password: String) async throws {
        try await Task.sleep(for: .milliseconds(1500))
        let emailLooksValid = email
            .trimmingCharacters(in: .whitespaces)
            .range(of: #"^\S+@\S+\.\S+$"#, options: .regularExpression) != nil
        guard emailLooksValid, password.count >= 6 else {
            throw AccountError.invalidCredentials
        }
    }
}
