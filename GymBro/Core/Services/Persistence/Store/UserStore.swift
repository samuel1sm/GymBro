import Foundation

protocol UserStore {

    // MARK: Profile

    func loadUser() throws -> StoredUser?

    /// Creates the profile, or updates it in place if one already exists.
    @discardableResult
    func saveUser(_ profile: AIPlan.PlanRequest) throws -> StoredUser

    // MARK: Plans

    func savePlan(_ plan: AIPlan.WorkoutPlan, for user: StoredUser, name: String?) throws
    func loadSavedPlans(for user: StoredUser) throws -> [StoredPlan]
    func deletePlan(_ plan: StoredPlan) throws

    // MARK: Logging seam (future watch layer)

    /// Opens a log for a session about to be performed. The future WCSession
    /// layer calls this when a watch workout starts.
    func startWorkoutLog(planId: UUID, sessionId: UUID, for user: StoredUser) throws -> StoredWorkoutLog

    /// Merges sets into a log, upserting by `StoredLoggedSet.id` (existing ids are
    /// updated, new ids inserted) — so the future watch merge never duplicates.
    func upsertLoggedSets(_ sets: [StoredLoggedSet], into log: StoredWorkoutLog) throws

    func loadLogs(for user: StoredUser) throws -> [StoredWorkoutLog]
}
