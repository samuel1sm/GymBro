import Foundation

extension AIPlan {

    /// User profile sent to the AI to generate a plan.
    struct PlanRequest: Codable, Sendable, Hashable {
        var name: String?
        var birthDate: Date
        var sex: BiologicalSex
        var weightKg: Double
        var heightCm: Double
        var unitSystem: UnitSystem
        var fitnessLevel: FitnessLevel
        var goals: [FitnessGoal]
        var focusMuscleGroups: [MuscleGroup]
        var availableEquipment: [Equipment]
        var injuriesAndLimitations: String?
        var daysPerWeek: Int
        var sessionDurationMinutes: Int
        var preferredTrainingDays: [Weekday] = []
        var preferredSplit: SplitType

        var age: Int {
            Calendar.current.dateComponents([.year], from: birthDate, to: .now).year ?? 0
        }
    }

    struct MuscleGroups: Codable, Sendable, Hashable {
        var primary: [MuscleGroup]
        var secondary: [MuscleGroup]
    }

    struct AlternativeExercise: Codable, Sendable, Hashable {
        var name: String
        var equipment: Equipment
        var muscles: MuscleGroups
        var coachingNotes: String?
        var videoUrl: String?
    }

    struct Exercise: Codable, Sendable, Hashable {
        var name: String
        var equipment: Equipment
        var muscles: MuscleGroups
        var sets: Int
        var repsMin: Int
        var repsMax: Int
        var restSeconds: Int
        var rpeTarget: Double?
        var coachingNotes: String?
        var videoUrl: String?
        var alternatives: [AlternativeExercise]
    }

    /// Self-contained unit — this is what the watch will receive later.
    struct WorkoutSession: Codable, Sendable, Hashable {
        var sessionNumber: Int
        var focus: String
        var suggestedDay: String?
        var estimatedDurationMinutes: Int
        var warmupNotes: String?
        var cooldownNotes: String?
        var exercises: [Exercise]
    }

    struct WorkoutPlan: Codable, Sendable, Hashable {
        var splitType: SplitType
        var weeklySessionCount: Int
        var planNotes: String?
        var sessions: [WorkoutSession]
    }
}
