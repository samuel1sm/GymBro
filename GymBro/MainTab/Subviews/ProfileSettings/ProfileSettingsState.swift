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
    var equipment: [EquipmentOption] = [.fullGym]
    var injuries: String = "Left knee"

    // MARK: - Schedule

    var daysPerWeek: Int = 4
    var sessionMinutes: Int = 60
    var preferredSplit: String = "Push / Pull / Legs"
    var trainingDays: [TrainingDay] = [.monday, .tuesday, .thursday, .friday]

    // MARK: - App settings

    var weightUnit: WeightUnit = .kg
    var notificationsEnabled: Bool = true
    var restTimerSound: Bool = true

    // MARK: - Derived

    /// The `UserDefaults`-backed slice of this state, as one value so the view
    /// can observe and persist it with a single `onChange`.
    var appSettings: AppSettings {
        get {
            AppSettings(
                weightUnit: weightUnit,
                notificationsEnabled: notificationsEnabled,
                restTimerSound: restTimerSound
            )
        }
        set {
            weightUnit = newValue.weightUnit
            notificationsEnabled = newValue.notificationsEnabled
            restTimerSound = newValue.restTimerSound
        }
    }

    var initials: String {
        let parts = name.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first.map(String.init) }.joined()
    }

    var statsLine: String {
        "\(age) · \(weightDisplay) · \(heightCm) cm"
    }

    var weightDisplay: String {
        weightUnit == .lbs
            ? "\(Int((Double(weightKg) / 0.45359237).rounded())) lbs"
            : "\(weightKg) kg"
    }

    var goalsDisplay: String {
        goals.isEmpty ? "None" : goals.map(\.rawValue).joined(separator: ", ")
    }

    var equipmentDisplay: String {
        equipment.isEmpty ? "None" : equipment.map(\.rawValue).joined(separator: ", ")
    }

    var trainingDaysDisplay: String {
        trainingDays.isEmpty ? "Flexible" : trainingDays.map(\.rawValue).joined(separator: ", ")
    }
}
