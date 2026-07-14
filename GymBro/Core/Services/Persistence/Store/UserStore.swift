import Foundation

/// One exercise's edited prescription, matched to `StoredExercise.id`. Nil
/// fields (free-text inputs that didn't parse) leave the stored value untouched.
struct SessionExerciseEdit {
    let id: UUID
    let sets: Int
    let repsMin: Int?
    let repsMax: Int?
    let restSeconds: Int?
}

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

    /// Applies an in-place edit to a stored session: rename/refocus, update the
    /// surviving exercises (matched by id, reordered to the array order) and
    /// delete the ones no longer present.
    func updateSession(
        _ session: StoredSession,
        name: String?,
        focus: String,
        estimatedDurationMinutes: Int,
        exercises: [SessionExerciseEdit]
    ) throws

    // MARK: Logging

    /// Saves a finished workout in one shot — the phone flow calls this when
    /// the user ends an active session.
    func saveCompletedWorkout(
        planId: UUID,
        sessionId: UUID,
        startedAt: Date,
        completedAt: Date,
        sets: [StoredLoggedSet],
        for user: StoredUser
    ) throws

    // MARK: Logging seam (future watch layer)

    /// Opens a log for a session about to be performed. The future WCSession
    /// layer calls this when a watch workout starts.
    func startWorkoutLog(planId: UUID, sessionId: UUID, for user: StoredUser) throws -> StoredWorkoutLog

    /// Merges sets into a log, upserting by `StoredLoggedSet.id` (existing ids are
    /// updated, new ids inserted) — so the future watch merge never duplicates.
    func upsertLoggedSets(_ sets: [StoredLoggedSet], into log: StoredWorkoutLog) throws

    func loadLogs(for user: StoredUser) throws -> [StoredWorkoutLog]
}
