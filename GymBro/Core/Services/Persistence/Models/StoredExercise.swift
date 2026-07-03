import Foundation
import SwiftData

/// A prescribed exercise. `orderIndex` preserves the AI's ordering across
/// SwiftData's unordered relationships.
@Model
final class StoredExercise {

    @Attribute(.unique) var id: UUID

    var name: String
    var equipment: String
    var orderIndex: Int
    var sets: Int
    var repsMin: Int
    var repsMax: Int
    var restSeconds: Int
    var rpeTarget: Double?
    var coachingNotes: String?
    var videoUrl: String?

    var primaryMuscles: [String]
    var secondaryMuscles: [String]

    var session: StoredSession?

    @Relationship(deleteRule: .cascade, inverse: \StoredAlternative.exercise)
    var alternatives: [StoredAlternative] = []

    init(
        id: UUID = UUID(),
        name: String,
        equipment: String,
        orderIndex: Int,
        sets: Int,
        repsMin: Int,
        repsMax: Int,
        restSeconds: Int,
        rpeTarget: Double? = nil,
        coachingNotes: String? = nil,
        videoUrl: String? = nil,
        primaryMuscles: [String],
        secondaryMuscles: [String]
    ) {
        self.id = id
        self.name = name
        self.equipment = equipment
        self.orderIndex = orderIndex
        self.sets = sets
        self.repsMin = repsMin
        self.repsMax = repsMax
        self.restSeconds = restSeconds
        self.rpeTarget = rpeTarget
        self.coachingNotes = coachingNotes
        self.videoUrl = videoUrl
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
    }

    var orderedAlternatives: [StoredAlternative] {
        alternatives.sorted { $0.orderIndex < $1.orderIndex }
    }
}
