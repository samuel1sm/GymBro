import Foundation
import SwiftData

/// One workout to perform. Self-contained — the future WCSession layer sends a
/// single `StoredSession` to the watch as one unit.
@Model
final class StoredSession {

    @Attribute(.unique) var id: UUID

    var sessionNumber: Int
    /// User-given name from the workout editor — nil shows "Training N".
    var name: String?
    var focus: String
    var suggestedDay: String?
    var estimatedDurationMinutes: Int
    var warmupNotes: String?
    var cooldownNotes: String?

    var plan: StoredPlan?

    @Relationship(deleteRule: .cascade, inverse: \StoredExercise.session)
    var exercises: [StoredExercise] = []

    init(
        id: UUID = UUID(),
        sessionNumber: Int,
        name: String? = nil,
        focus: String,
        suggestedDay: String? = nil,
        estimatedDurationMinutes: Int,
        warmupNotes: String? = nil,
        cooldownNotes: String? = nil
    ) {
        self.id = id
        self.sessionNumber = sessionNumber
        self.name = name
        self.focus = focus
        self.suggestedDay = suggestedDay
        self.estimatedDurationMinutes = estimatedDurationMinutes
        self.warmupNotes = warmupNotes
        self.cooldownNotes = cooldownNotes
    }

    var orderedExercises: [StoredExercise] {
        exercises.sorted { $0.orderIndex < $1.orderIndex }
    }
}
