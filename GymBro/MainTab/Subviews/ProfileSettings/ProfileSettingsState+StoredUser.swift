import Foundation

extension ProfileSettingsState {

    /// Builds the state from the persisted profile. App-only settings
    /// (notifications, rest timer sound) keep their defaults — they aren't stored.
    init(user: StoredUser) {
        self.init()
        let request = PlanMapper.toRequest(user)

        name = request.name ?? "GymBro"
        age = Calendar.current.dateComponents([.year], from: request.birthDate, to: .now).year ?? age
        weightKg = Int(request.weightKg.rounded())
        heightCm = Int(request.heightCm.rounded())
        fitnessLevel = request.fitnessLevel.toUI

        goals = request.goals.map(\.toUI)
        equipment = request.availableEquipment.map(\.toUI)
        injuries = request.injuriesAndLimitations ?? "None"

        daysPerWeek = request.daysPerWeek
        sessionMinutes = request.sessionDurationMinutes
        preferredSplit = request.preferredSplit.displayName
        trainingDays = request.preferredTrainingDays.map(\.toUI)

        weightUnit = request.unitSystem == .imperial ? .lbs : .kg
    }
}

private extension AIPlan.SplitType {
    var displayName: String {
        switch self {
        case .fullBody:     return "Full Body"
        case .upperLower:   return "Upper / Lower"
        case .pushPullLegs: return "Push / Pull / Legs"
        case .bodyPart:     return "Body Part Split"
        case .custom:       return "Custom"
        }
    }
}
