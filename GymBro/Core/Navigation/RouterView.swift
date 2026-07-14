import SwiftUI

struct RouterView<Root: View>: View {
    @State private var coordinator = Coordinator()
    private let root: Root

    init(@ViewBuilder root: () -> Root) {
        self.root = root()
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            root.navigationDestination(for: Route.self) { route in
                    switch route {
                    case .firstOnboarding:
                        OnboardingView()
                    case .accountInformation:
                        SignInView()
                    case .signUp:
                        SignUpView()
                    case .profileGoals(let prefill):
                        ProfileGoalsView(prefill: prefill)
                    case .forgotPassword:
                        ForgotPasswordView()
                    case .planGeneration(let request, let flow):
                        PlanGenerationView(request: request, flow: flow)
                    case .plannerReview(let flow):
                        PlannerReviewView(flow: flow)
                    case .editWorkout(let context):
                        EditWorkoutView(context: context)
                    case .activeSession(let context):
                        ActiveSessionView(context: context)
                    case .main:
                        MainTabView()
                    }
                }
        }
        .environment(\.coordinator, coordinator)
    }
}
