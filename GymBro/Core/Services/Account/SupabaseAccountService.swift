import Foundation
import Supabase

/// Real backend auth. Maps the Supabase error codes the UI knows how to
/// message onto `AccountError`; anything else surfaces its own description.
nonisolated struct SupabaseAccountService: AccountService {

    private let client: SupabaseClient

    init(
        client: SupabaseClient = SupabaseClient(
            supabaseURL: SupabaseConfig.url,
            supabaseKey: SupabaseConfig.publishableKey
        )
    ) {
        self.client = client
    }

    func createAccount(email: String, password: String) async throws {
        do {
            _ = try await client.auth.signUp(email: email, password: password)
        } catch {
            throw Self.mapped(error)
        }
    }

    func signIn(email: String, password: String) async throws {
        do {
            _ = try await client.auth.signIn(email: email, password: password)
        } catch {
            throw Self.mapped(error)
        }
    }

    func signInWithApple(idToken: String, nonce: String) async throws {
        do {
            _ = try await client.auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                    provider: .apple,
                    idToken: idToken,
                    nonce: nonce
                )
            )
        } catch {
            throw Self.mapped(error)
        }
    }

    /// A stored session counts even if the access token has expired — the app
    /// is local-first, and the SDK refreshes tokens on the next backend call.
    func hasRestorableSession() async -> Bool {
        client.auth.currentSession != nil
    }

    /// Best effort: server-side token revocation can fail offline, but the
    /// SDK still drops the local session, which is what launch routing checks.
    func signOut() async {
        try? await client.auth.signOut()
    }

    private static func mapped(_ error: any Error) -> any Error {
        guard let authError = error as? AuthError else { return error }
        switch authError.errorCode {
        case .userAlreadyExists, .emailExists:
            return AccountError.emailAlreadyRegistered
        case .invalidCredentials:
            return AccountError.invalidCredentials
        default:
            return authError
        }
    }
}
