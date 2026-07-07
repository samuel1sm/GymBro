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

    /// Rebuilds the flow state from a saved request so the user edits their
    /// existing data instead of the defaults. Injury areas and notes are
    /// re-split from the flattened `injuriesAndLimitations` summary best-effort.
    init(request: AIPlan.PlanRequest) {
        self.init()

        birthDate = request.birthDate
        sex = request.sex.toUI
        weightUnit = request.unitSystem == .imperial ? .lbs : .kg
        heightUnit = request.unitSystem == .imperial ? .inches : .cm
        weightKg = Int(request.weightKg.rounded())
        weightLbs = Int((request.weightKg / 0.45359237).rounded())
        heightCm = Int(request.heightCm.rounded())
        heightIn = Int((request.heightCm / 2.54).rounded())

        fitnessLevel = request.fitnessLevel.toUI
        goals = request.goals.map(\.toUI)
        daysPerWeek = request.daysPerWeek
        sessionDurationMinutes = request.sessionDurationMinutes
        preferredDays = Set(request.preferredTrainingDays.map(\.toUI))
        equipment = Set(request.availableEquipment.map(\.toUI))

        if let summary = request.injuriesAndLimitations {
            let areas = InjuryArea.allCases.filter { $0 != .none && summary.contains($0.rawValue) }
            injuries = Set(areas)
            var notes = summary
            for area in areas {
                notes = notes.replacingOccurrences(of: area.rawValue, with: "")
            }
            injuryNotes = notes.trimmingCharacters(in: CharacterSet(charactersIn: " ,.\n"))
        } else {
            injuries = [.none]
        }
    }
}

// MARK: - AIPlan -> UI (shared with Profile & Settings)

extension AIPlan.BiologicalSex {
    var toUI: BiologicalSex {
        switch self {
        case .male:        return .male
        case .female:      return .female
        case .unspecified: return .preferNotToSay
        }
    }
}

extension AIPlan.FitnessLevel {
    var toUI: FitnessLevel {
        switch self {
        case .beginner:     return .beginner
        case .intermediate: return .intermediate
        case .advanced:     return .advanced
        }
    }
}

extension AIPlan.FitnessGoal {
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

extension AIPlan.Equipment {
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

extension AIPlan.Weekday {
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
