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
                    case .profileGoals:
                        ProfileGoalsView()
                    case .forgotPassword:
                        ForgotPasswordView()
                    case .planGeneration:
                        PlanGenerationView()
                    case .plannerReview:
                        PlannerReviewView()
                    case .activeSession:
                        ActiveSessionView()
                    case .profileSettings:
                        ProfileSettingsView()
                    }
                }
        }
        .environment(\.coordinator, coordinator)
    }
}
