import Foundation
import Observation

/// View model for the Forgot Password screen.
///
/// Owns the recovery form state and the demo "send reset link" flow. The view
/// is a thin `@Bindable` projection of this object. The request is simulated
/// with a short delay; replace `submit()`'s body with a real network call when
/// a backend exists.
@Observable
final class ForgotPasswordViewModel {

    var state: ForgotPasswordState

    /// In-flight send attempt, cancelled if the user submits again or the
    /// screen goes away mid-request.
    @ObservationIgnored private var sendTask: Task<Void, Never>?

    init(state: ForgotPasswordState = ForgotPasswordState()) {
        self.state = state
    }

    deinit {
        sendTask?.cancel()
    }

    /// "Sends" the reset link. An invalid email or an in-flight request is a
    /// no-op. For privacy the confirmation shows regardless of whether the
    /// address actually exists.
    func submit() {
        guard state.status != .loading, state.emailIsValid else { return }

        state.status = .loading

        sendTask?.cancel()
        sendTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .milliseconds(1400))
            guard let self, !Task.isCancelled else { return }
            self.state.status = .idle
            self.state.sent = true
        }
    }
}
