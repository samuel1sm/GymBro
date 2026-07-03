import Foundation
import SwiftData

/// Source device of a logged set, for future phone/watch reconciliation.
enum DeviceOrigin: String, Codable, Sendable {
    case phone
    case watch
}

/// One logged set. `id` is the stable merge key — the watch may resend sets, and
/// `UserStore.upsertLoggedSets` updates by id instead of duplicating.
@Model
final class StoredLoggedSet {

    @Attribute(.unique) var id: UUID

    /// The `StoredExercise` performed.
    var exerciseId: UUID
    var setIndex: Int
    var weightKg: Double
    var repsCompleted: Int
    var rpe: Int?
    var loggedAt: Date
    var deviceOrigin: DeviceOrigin

    var log: StoredWorkoutLog?

    init(
        id: UUID = UUID(),
        exerciseId: UUID,
        setIndex: Int,
        weightKg: Double,
        repsCompleted: Int,
        rpe: Int? = nil,
        loggedAt: Date = .now,
        deviceOrigin: DeviceOrigin = .phone
    ) {
        self.id = id
        self.exerciseId = exerciseId
        self.setIndex = setIndex
        self.weightKg = weightKg
        self.repsCompleted = repsCompleted
        self.rpe = rpe
        self.loggedAt = loggedAt
        self.deviceOrigin = deviceOrigin
    }
}
