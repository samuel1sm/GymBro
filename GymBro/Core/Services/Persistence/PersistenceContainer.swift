import Foundation
import SwiftData

/// Every stored `@Model` type, listed once. Storage is local-only — the future
/// watch sync goes over WCSession, not CloudKit.
enum PersistenceSchema {

    static let models: [any PersistentModel.Type] = [
        StoredUser.self,
        StoredPlan.self,
        StoredSession.self,
        StoredExercise.self,
        StoredAlternative.self,
        StoredWorkoutLog.self,
        StoredLoggedSet.self,
    ]

    static var schema: Schema { Schema(models) }
}

enum PersistenceContainer {

    static func makeShared() throws -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: PersistenceSchema.schema,
            isStoredInMemoryOnly: false
        )
        return try ModelContainer(for: PersistenceSchema.schema, configurations: configuration)
    }

    static func makeInMemory() throws -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: PersistenceSchema.schema,
            isStoredInMemoryOnly: true
        )
        return try ModelContainer(for: PersistenceSchema.schema, configurations: configuration)
    }
}
