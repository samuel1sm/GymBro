import Foundation
import Observation

/// View model for the Sign In screen.
///
/// Owns the auth form state and the demo authentication flow. The view is a
/// thin `@Bindable` projection of this object. Authentication is simulated
/// with a short delay; replace `authenticate()` with a real network call when
/// a backend exists.
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

    /// Attempts to sign in with the current credentials.
    ///
    /// Empty fields short-circuit to an inline error. Otherwise we enter the
    /// loading state, simulate a request, then resolve to success or error.
    /// On success the prototype returns to idle after a beat; once a Home
    /// screen exists this is where you'd route there instead.
    func submit() {
        guard state.status != .loading else { return }

        guard state.hasBothFields else {
            state.status = .error
            state.errorMessage = String(localized: "Enter your email and password.")
            return
        }

        state.status = .loading
        state.errorMessage = ""

        authTask?.cancel()
        authTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .milliseconds(1500))
            guard let self, !Task.isCancelled else { return }

            if self.state.credentialsAreValid {
                self.state.status = .success
                try? await Task.sleep(for: .milliseconds(1600))
                guard !Task.isCancelled else { return }
                self.state.status = .idle
            } else {
                self.state.status = .error
                self.state.errorMessage = String(localized: "Incorrect email or password.")
            }
        }
    }

    func toggleReveal() {
        state.revealPassword.toggle()
    }
}
