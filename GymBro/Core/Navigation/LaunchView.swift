import SwiftUI

/// Root of the navigation stack. If an account already exists on device,
/// skips onboarding and goes straight to Sign In — even if a generated plan
/// is still stashed (Sign In routes to Planner Review to save it). Otherwise,
/// a stashed plan means the user never signed up, so it skips straight to the
/// Save Plan gate so the plan isn't lost behind onboarding.
struct LaunchView: View {
    @Environment(\.coordinator) private var coordinator
    @Environment(\.pendingPlanStore) private var pendingPlanStore
    @Environment(\.userStore) private var userStore

    var body: some View {
        OnboardingView()
            .onAppear {
                if (try? userStore.loadUser()) != nil {
                    coordinator.push(.accountInformation)
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
