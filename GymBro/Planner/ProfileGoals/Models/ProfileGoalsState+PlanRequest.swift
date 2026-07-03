import Foundation

extension ProfileGoalsState {

    /// The preferred split isn't collected in this flow yet, so it defaults to `.custom`.
    func toPlanRequest() -> AIPlan.PlanRequest {
        AIPlan.PlanRequest(
            name: nil,
            birthDate: birthDate,
            sex: sex.toAIPlan,
            weightKg: weightUnit == .lbs ? Double(weightLbs) * 0.45359237 : Double(weightKg),
            heightCm: heightUnit == .inches ? Double(heightIn) * 2.54 : Double(heightCm),
            unitSystem: weightUnit == .lbs ? .imperial : .metric,
            fitnessLevel: fitnessLevel.toAIPlan,
            goals: goals.map(\.toAIPlan),
            focusMuscleGroups: [],
            availableEquipment: equipment.map(\.toAIPlan).sorted { $0.rawValue < $1.rawValue },
            injuriesAndLimitations: injuriesSummary,
            daysPerWeek: daysPerWeek,
            sessionDurationMinutes: sessionDurationMinutes,
            preferredTrainingDays: TrainingDay.allCases.filter(preferredDays.contains).map(\.toAIPlan),
            preferredSplit: .custom
        )
    }

    private var injuriesSummary: String? {
        var parts: [String] = []
        let areas = injuries.filter { $0 != .none }.map(\.rawValue).sorted()
        if !areas.isEmpty { parts.append(areas.joined(separator: ", ")) }
        let notes = injuryNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        if !notes.isEmpty { parts.append(notes) }
        return parts.isEmpty ? nil : parts.joined(separator: ". ")
    }
}

private extension BiologicalSex {
    var toAIPlan: AIPlan.BiologicalSex {
        switch self {
        case .male:           return .male
        case .female:         return .female
        case .preferNotToSay: return .unspecified
        }
    }
}

private extension FitnessLevel {
    var toAIPlan: AIPlan.FitnessLevel {
        switch self {
        case .beginner:     return .beginner
        case .intermediate: return .intermediate
        case .advanced:     return .advanced
        }
    }
}

private extension FitnessGoal {
    var toAIPlan: AIPlan.FitnessGoal {
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

private extension TrainingDay {
    var toAIPlan: AIPlan.Weekday {
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

private extension EquipmentOption {
    var toAIPlan: AIPlan.Equipment {
        switch self {
        case .bodyweightOnly:  return .bodyweight
        case .dumbbells:       return .dumbbells
        case .barbellPlates:   return .barbell
        case .kettlebells:     return .kettlebell
        case .resistanceBands: return .resistanceBands
        case .pullupBar:       return .pullupBar
        case .cableMachine:    return .cableMachine
        case .fullGym:         return .fullGym
        }
    }
}
