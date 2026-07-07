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

private extension AIPlan.FitnessLevel {
    var toUI: FitnessLevel {
        switch self {
        case .beginner:     return .beginner
        case .intermediate: return .intermediate
        case .advanced:     return .advanced
        }
    }
}

private extension AIPlan.FitnessGoal {
    var toUI: FitnessGoal {
        switch self {
        case .muscleGain:          return .muscleGain
        case .fatLoss:             return .fatLoss
        case .strength:            return .strength
        case .endurance:           return .endurance
        case .flexibility:         return .flexibility
        case .generalFitness:      return .generalFitness
        case .athleticPerformance: return .athleticPerformance
        }
    }
}

private extension AIPlan.Equipment {
    var toUI: EquipmentOption {
        switch self {
        case .bodyweight:      return .bodyweightOnly
        case .dumbbells:       return .dumbbells
        case .barbell:         return .barbellPlates
        case .kettlebell:      return .kettlebells
        case .resistanceBands: return .resistanceBands
        case .pullupBar:       return .pullupBar
        case .cableMachine:    return .cableMachine
        case .fullGym:         return .fullGym
        }
    }
}

private extension AIPlan.Weekday {
    var toUI: TrainingDay {
        switch self {
        case .monday:    return .monday
        case .tuesday:   return .tuesday
        case .wednesday: return .wednesday
        case .thursday:  return .thursday
        case .friday:    return .friday
        case .saturday:  return .saturday
        case .sunday:    return .sunday
        }
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
