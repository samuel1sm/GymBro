import SwiftUI

/// Root of the navigation stack. An account on device with a live auth
/// session skips straight into the app; without a session it goes to Sign In —
/// even if a generated plan is still stashed (Sign In routes to Planner Review
/// to save it). Otherwise, a stashed plan means the user never signed up, so
/// it skips straight to the Save Plan gate so the plan isn't lost behind
/// onboarding.
struct LaunchView: View {
    @Environment(\.coordinator) private var coordinator
    @Environment(\.pendingPlanStore) private var pendingPlanStore
    @Environment(\.userStore) private var userStore
    @Environment(\.accountService) private var accountService

    /// Routing runs once per launch — popping back here (e.g. from Sign In's
    /// back chevron) must reveal onboarding, not re-trigger the redirect.
    @State private var hasRouted = false

    var body: some View {
        OnboardingView()
            .task {
                guard !hasRouted else { return }
                hasRouted = true

                if (try? userStore.loadUser()) != nil {
                    if await accountService.hasRestorableSession() {
                        coordinator.replaceRoot(LoginFlow.postSignInRoute(using: userStore))
                    } else {
                        coordinator.push(.accountInformation)
                    }
                } else if pendingPlanStore.hasPendingPlan {
                    coordinator.push(.signUp)
                }
            }
    }
}

#Preview {
    RouterView {
        LaunchView()
    }
}
