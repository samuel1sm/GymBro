import Foundation

/// Profile & Settings — preferences, personal data summary, and app settings.
struct ProfileSettingsState {

    // MARK: - Personal

    var name: String = "Alex Rivera"
    var age: Int = 28
    var weightKg: Int = 78
    var heightCm: Int = 176
    var fitnessLevel: FitnessLevel = .intermediate

    // MARK: - Training preferences

    var goals: [FitnessGoal] = [.muscleGain, .fatLoss]
    var equipment: EquipmentOption = .fullGym
    var injuries: String = "Left knee"

    // MARK: - Schedule

    var daysPerWeek: Int = 4
    var sessionMinutes: Int = 60
    var preferredSplit: String = "Push / Pull / Legs"
    var workoutTime: String = "Morning"

    // MARK: - App settings

    var weightUnit: WeightUnit = .kg
    var notificationsEnabled: Bool = true
    var restTimerSound: Bool = true

    // MARK: - Derived

    var initials: String {
        let parts = name.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first.map(String.init) }.joined()
    }

    var statsLine: String {
        "\(age) · \(weightKg) kg · \(heightCm) cm"
    }

    var goalsDisplay: String {
        goals.map(\.rawValue).joined(separator: ", ")
    }
}
