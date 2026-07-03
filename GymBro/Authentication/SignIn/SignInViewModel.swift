import Foundation
import Observation

/// View model for the Sign In screen.
///
/// Owns the auth form state and drives authentication through `AccountService`
/// (mocked for now). Persisting a pending plan happens later, on the Planner
/// Review screen — this screen only authenticates and routes.
@Observable
final class SignInViewModel {

    var state: SignInState

    /// In-flight auth attempt, cancelled if the user submits again or the
    /// screen goes away mid-request.
    @ObservationIgnored private var authTask: Task<Void, Never>?

    init(state: SignInState = SignInState()) {
        self.state = state
    }

    deinit {
        authTask?.cancel()
    }

    /// Attempts to sign in with the current credentials. `onSuccess` fires
    /// after the success state has been shown for a beat — the view routes
    /// onward there.
    ///
    /// Empty fields short-circuit to an inline error.
    func submit(
        accountService: AccountService,
        onSuccess: @escaping () -> Void = {}
    ) {
        guard state.status != .loading else { return }

        guard state.hasBothFields else {
            state.status = .error
            state.errorMessage = String(localized: "Enter your email and password.")
            return
        }

        state.status = .loading
        state.errorMessage = ""

        let email = state.email
        let password = state.password

        authTask?.cancel()
        authTask = Task { @MainActor [weak self] in
            do {
                try await accountService.signIn(email: email, password: password)
                guard let self, !Task.isCancelled else { return }
                self.state.status = .success
                try? await Task.sleep(for: .milliseconds(900))
                guard !Task.isCancelled else { return }
                onSuccess()
            } catch {
                guard let self, !Task.isCancelled else { return }
                self.state.status = .error
                self.state.errorMessage = error.localizedDescription
            }
        }
    }

    func toggleReveal() {
        state.revealPassword.toggle()
    }
}
