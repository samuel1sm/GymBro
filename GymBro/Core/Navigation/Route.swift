import SwiftUI

enum Route: Hashable {
    case firstOnboarding
    case accountInformation
    case signUp
    case profileGoals
    case forgotPassword
    case planGeneration(AIPlan.PlanRequest)
    case plannerReview
    case editWorkout
    case activeSession
    case main
}
