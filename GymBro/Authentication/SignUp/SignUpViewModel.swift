import Foundation
import Observation

/// View model for the Sign Up (Save Plan Gate) screen.
///
/// Owns the form state and the demo account-creation flow. The view is a thin
/// `@Bindable` projection of this object. Account creation is simulated with a
/// short delay; replace `createAccount()` with a real network call when a
/// backend exists. On success the anonymous profile + plan would migrate to the
/// new account and route to Home — for now the prototype returns to idle.
@Observable
final class SignUpViewModel {

    var state: SignUpState

    /// In-flight create attempt, cancelled if the user submits again or the
    /// screen goes away mid-request.
    @ObservationIgnored private var createTask: Task<Void, Never>?

    init(state: SignUpState = SignUpState()) {
        self.state = state
    }

    deinit {
        createTask?.cancel()
    }

    /// Creates an account with the current credentials.
    ///
    /// No-ops unless the form is valid (the CTA is disabled in that case too).
    /// Enters the loading state, simulates a request, then resolves to success
    /// or error. Demo rule (mirrors the prototype): an email containing "taken"
    /// simulates a duplicate-account error; anything else succeeds.
    func submit() {
        guard state.canSubmit() else { return }

        state.status = .loading
        state.errorMessage = ""

        createTask?.cancel()
        createTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .milliseconds(1500))
            guard let self, !Task.isCancelled else { return }

            if self.state.email.range(of: "taken", options: .caseInsensitive) != nil {
                self.state.status = .error
                self.state.errorMessage = String(
                    localized: "That email is already registered. Try signing in."
                )
            } else {
                self.state.status = .success
                try? await Task.sleep(for: .milliseconds(1800))
                guard !Task.isCancelled else { return }
                self.state.status = .idle
            }
        }
    }

    func toggleReveal() {
        state.revealPassword.toggle()
    }
}
