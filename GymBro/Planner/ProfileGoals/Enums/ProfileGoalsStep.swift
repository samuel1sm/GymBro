import Foundation

enum ProfileGoalsStep: Int, CaseIterable {
    case physical = 1
    case fitnessLevel
    case goals
    case equipment
    case injuries

    static var totalSteps: Int { allCases.count }

    var next: ProfileGoalsStep? {
        ProfileGoalsStep(rawValue: rawValue + 1)
    }

    var previous: ProfileGoalsStep? {
        ProfileGoalsStep(rawValue: rawValue - 1)
    }
}
