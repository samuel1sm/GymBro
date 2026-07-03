import Foundation
import SwiftData

/// A saved workout plan, mapped to/from `AIPlan.WorkoutPlan` by `PlanMapper`.
@Model
final class StoredPlan {

    @Attribute(.unique) var id: UUID

    /// User-defined save name, distinct from the AI-derived `splitType`.
    var name: String?

    var splitType: String
    var weeklySessionCount: Int
    var planNotes: String?

    var generatedAt: Date
    var savedAt: Date

    var user: StoredUser?

    @Relationship(deleteRule: .cascade, inverse: \StoredSession.plan)
    var sessions: [StoredSession] = []

    init(
        id: UUID = UUID(),
        name: String? = nil,
        splitType: String,
        weeklySessionCount: Int,
        planNotes: String? = nil,
        generatedAt: Date = .now,
        savedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.splitType = splitType
        self.weeklySessionCount = weeklySessionCount
        self.planNotes = planNotes
        self.generatedAt = generatedAt
        self.savedAt = savedAt
    }

    /// SwiftData to-many relationships are unordered — read sessions through this.
    var orderedSessions: [StoredSession] {
        sessions.sorted { $0.sessionNumber < $1.sessionNumber }
    }
}
