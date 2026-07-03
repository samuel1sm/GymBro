import Foundation

struct ProfileGoalsState {
    var birthDate: Date = Calendar.current.date(byAdding: .year, value: -28, to: .now) ?? .now
    var weightLbs: Int = 180
    var weightKg: Int = 82
    var weightUnit: WeightUnit = .lbs
    var heightIn: Int = 70
    var heightCm: Int = 178
    var heightUnit: HeightUnit = .inches
    var sex: BiologicalSex = .male

    var fitnessLevel: FitnessLevel = .intermediate

    var goals: [FitnessGoal] = []
    var daysPerWeek: Int = 4
    var sessionDurationMinutes: Int = 60
    var preferredDays: Set<TrainingDay> = []

    var equipment: Set<EquipmentOption> = []

    var injuryNotes: String = ""
    var injuries: Set<InjuryArea> = []

    var weightDisplay: String {
        weightUnit == .lbs ? "\(weightLbs)" : "\(weightKg)"
    }

    var heightDisplay: String {
        if heightUnit == .inches {
            return "\(heightIn / 12)' \(heightIn % 12)\""
        }
        return "\(heightCm)"
    }
}
