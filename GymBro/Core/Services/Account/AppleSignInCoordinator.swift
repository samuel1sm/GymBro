import AuthenticationServices
import CryptoKit
import UIKit

/// Runs the native Sign in with Apple sheet and returns the pieces Supabase
/// needs: the identity token plus the raw nonce baked into the request.
final class AppleSignInCoordinator: NSObject {

    struct Credential {
        let idToken: String
        let nonce: String
        let fullName: PersonNameComponents?
    }

    enum AppleSignInError: LocalizedError {
        case invalidCredential

        var errorDescription: String? {
            String(localized: "Apple sign-in didn't return a valid credential. Please try again.")
        }
    }

    private var continuation: CheckedContinuation<Credential, any Error>?
    private var currentNonce = ""

    func signIn() async throws -> Credential {
        currentNonce = Self.randomNonce()

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = Self.sha256(currentNonce)

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    private static func randomNonce(length: Int = 32) -> String {
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        return String((0..<length).map { _ in charset.randomElement()! })
    }

    private static func sha256(_ input: String) -> String {
        SHA256.hash(data: Data(input.utf8))
            .map { String(format: "%02x", $0) }
            .joined()
    }
}

/// `@preconcurrency`: the delegate protocols are nonisolated, but these
/// callbacks arrive on the main queue, where this MainActor class lives.
extension AppleSignInCoordinator: @preconcurrency ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        defer { continuation = nil }
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let idToken = String(data: tokenData, encoding: .utf8)
        else {
            continuation?.resume(throwing: AppleSignInError.invalidCredential)
            return
        }
        continuation?.resume(
            returning: Credential(
                idToken: idToken,
                nonce: currentNonce,
                fullName: credential.fullName
            )
        )
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

extension AppleSignInCoordinator: @preconcurrency ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
