import Foundation
import SwiftData

/// A substitute exercise attached to a `StoredExercise`.
@Model
final class StoredAlternative {

    @Attribute(.unique) var id: UUID

    var name: String
    var equipment: String
    var orderIndex: Int
    var coachingNotes: String?
    var videoUrl: String?

    var primaryMuscles: [String]
    var secondaryMuscles: [String]

    var exercise: StoredExercise?

    init(
        id: UUID = UUID(),
        name: String,
        equipment: String,
        orderIndex: Int,
        coachingNotes: String? = nil,
        videoUrl: String? = nil,
        primaryMuscles: [String],
        secondaryMuscles: [String]
    ) {
        self.id = id
        self.name = name
        self.equipment = equipment
        self.orderIndex = orderIndex
        self.coachingNotes = coachingNotes
        self.videoUrl = videoUrl
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
    }
}
