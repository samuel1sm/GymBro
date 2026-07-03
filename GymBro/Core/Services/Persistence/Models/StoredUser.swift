import Foundation
import SwiftData

/// On-device user profile. Enum fields are stored as raw `String`/`[String]`;
/// conversion lives in `PlanMapper`.
@Model
final class StoredUser {

    @Attribute(.unique) var id: UUID

    var name: String?
    var birthDate: Date
    var sex: String
    var weightKg: Double
    var heightCm: Double
    var unitSystem: String
    var fitnessLevel: String

    var goals: [String]
    var focusMuscleGroups: [String]
    var availableEquipment: [String]

    var injuriesAndLimitations: String?

    var daysPerWeek: Int
    var sessionDurationMinutes: Int
    var preferredTrainingDays: [String]
    var preferredSplit: String

    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \StoredPlan.user)
    var savedPlans: [StoredPlan] = []

    @Relationship(deleteRule: .cascade, inverse: \StoredWorkoutLog.user)
    var logs: [StoredWorkoutLog] = []

    init(
        id: UUID = UUID(),
        name: String? = nil,
        birthDate: Date,
        sex: String,
        weightKg: Double,
        heightCm: Double,
        unitSystem: String,
        fitnessLevel: String,
        goals: [String],
        focusMuscleGroups: [String],
        availableEquipment: [String],
        injuriesAndLimitations: String? = nil,
        daysPerWeek: Int,
        sessionDurationMinutes: Int,
        preferredTrainingDays: [String] = [],
        preferredSplit: String,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.birthDate = birthDate
        self.sex = sex
        self.weightKg = weightKg
        self.heightCm = heightCm
        self.unitSystem = unitSystem
        self.fitnessLevel = fitnessLevel
        self.goals = goals
        self.focusMuscleGroups = focusMuscleGroups
        self.availableEquipment = availableEquipment
        self.injuriesAndLimitations = injuriesAndLimitations
        self.daysPerWeek = daysPerWeek
        self.sessionDurationMinutes = sessionDurationMinutes
        self.preferredTrainingDays = preferredTrainingDays
        self.preferredSplit = preferredSplit
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
