import Foundation
import SwiftData

/// `UserStore` for previews and tests, forwarding to a `SwiftDataUserStore` on
/// an in-memory container.
final class InMemoryUserStore: UserStore {

    /// Exposed so tests can open a fresh `ModelContext` on the same container.
    let container: ModelContainer

    private let backing: SwiftDataUserStore

    init() throws {
        container = try PersistenceContainer.makeInMemory()
        backing = SwiftDataUserStore(context: ModelContext(container))
    }

    func loadUser() throws -> StoredUser? {
        try backing.loadUser()
    }

    @discardableResult
    func saveUser(_ profile: AIPlan.PlanRequest) throws -> StoredUser {
        try backing.saveUser(profile)
    }

    func savePlan(_ plan: AIPlan.WorkoutPlan, for user: StoredUser, name: String?) throws {
        try backing.savePlan(plan, for: user, name: name)
    }

    func loadSavedPlans(for user: StoredUser) throws -> [StoredPlan] {
        try backing.loadSavedPlans(for: user)
    }

    func deletePlan(_ plan: StoredPlan) throws {
        try backing.deletePlan(plan)
    }

    func startWorkoutLog(planId: UUID, sessionId: UUID, for user: StoredUser) throws -> StoredWorkoutLog {
        try backing.startWorkoutLog(planId: planId, sessionId: sessionId, for: user)
    }

    func upsertLoggedSets(_ sets: [StoredLoggedSet], into log: StoredWorkoutLog) throws {
        try backing.upsertLoggedSets(sets, into: log)
    }

    func loadLogs(for user: StoredUser) throws -> [StoredWorkoutLog] {
        try backing.loadLogs(for: user)
    }
}
