import Foundation
import SwiftData

/// SwiftData-backed `UserStore`, working on an injected `ModelContext`.
final class SwiftDataUserStore: UserStore {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Profile

    func loadUser() throws -> StoredUser? {
        var descriptor = FetchDescriptor<StoredUser>(
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    @discardableResult
    func saveUser(_ profile: AIPlan.PlanRequest) throws -> StoredUser {
        if let existing = try loadUser() {
            PlanMapper.apply(profile, to: existing)
            try context.save()
            return existing
        }
        let user = PlanMapper.makeUser(from: profile)
        context.insert(user)
        try context.save()
        return user
    }

    // MARK: - Plans

    func savePlan(_ plan: AIPlan.WorkoutPlan, for user: StoredUser, name: String?) throws {
        let stored = PlanMapper.toStored(plan: plan, request: nil, name: name)
        stored.user = user
        context.insert(stored)
        try context.save()
    }

    func loadSavedPlans(for user: StoredUser) throws -> [StoredPlan] {
        user.savedPlans.sorted { $0.savedAt > $1.savedAt }
    }

    func deletePlan(_ plan: StoredPlan) throws {
        context.delete(plan)
        try context.save()
    }

    func updateSession(
        _ session: StoredSession,
        name: String?,
        focus: String,
        estimatedDurationMinutes: Int,
        exercises edits: [SessionExerciseEdit]
    ) throws {
        session.name = name
        session.focus = focus
        session.estimatedDurationMinutes = estimatedDurationMinutes

        let orderByID = Dictionary(uniqueKeysWithValues: edits.enumerated().map { ($1.id, $0) })
        let removed = session.exercises.filter { orderByID[$0.id] == nil }
        removed.forEach(context.delete)

        for edit in edits {
            guard let exercise = session.exercises.first(where: { $0.id == edit.id }) else { continue }
            exercise.orderIndex = orderByID[edit.id] ?? exercise.orderIndex
            exercise.sets = edit.sets
            if let repsMin = edit.repsMin { exercise.repsMin = repsMin }
            if let repsMax = edit.repsMax { exercise.repsMax = repsMax }
            if let restSeconds = edit.restSeconds { exercise.restSeconds = restSeconds }
        }
        try context.save()
    }

    // MARK: - Logging

    func saveCompletedWorkout(
        planId: UUID,
        sessionId: UUID,
        startedAt: Date,
        completedAt: Date,
        sets: [StoredLoggedSet],
        for user: StoredUser
    ) throws {
        let log = StoredWorkoutLog(
            planId: planId,
            sessionId: sessionId,
            startedAt: startedAt,
            completedAt: completedAt
        )
        log.user = user
        context.insert(log)
        for set in sets {
            set.log = log
            context.insert(set)
        }
        try context.save()
    }

    // TODO: WCSession seam (send) — before a watch workout, fetch the matching
    // self-contained StoredSession, transfer it to the watch, and open the log here.
    func startWorkoutLog(planId: UUID, sessionId: UUID, for user: StoredUser) throws -> StoredWorkoutLog {
        let log = StoredWorkoutLog(planId: planId, sessionId: sessionId)
        log.user = user
        context.insert(log)
        try context.save()
        return log
    }

    // TODO: WCSession seam (receive) — decode sets reported by the watch into
    // StoredLoggedSet (deviceOrigin: .watch) and call this; upsert-by-id means
    // resent sets update in place rather than duplicating.
    func upsertLoggedSets(_ sets: [StoredLoggedSet], into log: StoredWorkoutLog) throws {
        for incoming in sets {
            if let existing = log.loggedSets.first(where: { $0.id == incoming.id }) {
                existing.exerciseId = incoming.exerciseId
                existing.setIndex = incoming.setIndex
                existing.weightKg = incoming.weightKg
                existing.repsCompleted = incoming.repsCompleted
                existing.rpe = incoming.rpe
                existing.loggedAt = incoming.loggedAt
                existing.deviceOrigin = incoming.deviceOrigin
            } else {
                incoming.log = log
                context.insert(incoming)
            }
        }
        try context.save()
    }

    func loadLogs(for user: StoredUser) throws -> [StoredWorkoutLog] {
        user.logs.sorted { $0.startedAt > $1.startedAt }
    }
}
