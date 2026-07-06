import Foundation
import Observation

/// View model for the Sign Up (Save Plan Gate) screen.
///
/// Owns the form state and drives account creation through `AccountService`
/// (mocked for now). On success the user profile is saved to SwiftData; the
/// plan itself is persisted later, on the Planner Review screen.
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

    /// Creates an account with the current credentials, then saves the user
    /// profile (not the plan) on success. `onSuccess` fires after the success
    /// state has been shown for a beat — the view routes onward there.
    ///
    /// No-ops unless the form is valid (the CTA is disabled in that case too).
    func submit(
        accountService: AccountService,
        userStore: UserStore,
        pendingPlan: PendingPlanStore,
        onSuccess: @escaping () -> Void = {}
    ) {
        guard state.canSubmit() else { return }

        state.status = .loading
        state.errorMessage = ""

        let email = state.email
        let password = state.password

        createTask?.cancel()
        createTask = Task { @MainActor [weak self] in
            do {
                try await accountService.createAccount(email: email, password: password)
                guard let self, !Task.isCancelled else { return }
                try pendingPlan.persistUser(to: userStore)
                self.state.status = .success
                try? await Task.sleep(for: AuthPrimaryCTA.successHold)
                guard !Task.isCancelled else { return }
                onSuccess()
            } catch {
                guard let self, !Task.isCancelled else { return }
                self.state.status = .error
                self.state.errorMessage = error.localizedDescription
            }
        }
    }

}
