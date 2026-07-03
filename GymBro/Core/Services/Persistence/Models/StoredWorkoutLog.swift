import Foundation
import SwiftData

/// A workout record — the storage target for the future WCSession return path.
/// `planId`/`sessionId` are plain UUIDs (not relationships) so a log survives
/// plan deletion and crosses the watch boundary as stable ids.
@Model
final class StoredWorkoutLog {

    @Attribute(.unique) var id: UUID

    var planId: UUID
    var sessionId: UUID

    var startedAt: Date
    var completedAt: Date?

    var user: StoredUser?

    @Relationship(deleteRule: .cascade, inverse: \StoredLoggedSet.log)
    var loggedSets: [StoredLoggedSet] = []

    init(
        id: UUID = UUID(),
        planId: UUID,
        sessionId: UUID,
        startedAt: Date = .now,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.planId = planId
        self.sessionId = sessionId
        self.startedAt = startedAt
        self.completedAt = completedAt
    }
}
