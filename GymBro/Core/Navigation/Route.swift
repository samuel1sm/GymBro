import SwiftUI

/// Which flow the plan-creation screens are running in — decides where the
/// flow exits to once the plan is generated (sign-up gate vs. back to Profile).
enum PlanFlow: Hashable {
    case onboarding
    case profileEdit
}

enum Route: Hashable {
    case firstOnboarding
    case accountInformation
    case signUp
    case profileGoals(prefill: AIPlan.PlanRequest?)
    case forgotPassword
    case planGeneration(AIPlan.PlanRequest, PlanFlow)
    case plannerReview(PlanFlow)
    case editWorkout
    case activeSession
    case main
}
