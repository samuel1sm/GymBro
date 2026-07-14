import Foundation

extension WorkoutsState {

    /// Builds the state from the persisted plan library. The most recently
    /// saved plan starts active; completed workout logs mark sessions Done and
    /// the first pending session becomes Today.
    init(storedPlans: [StoredPlan], logs: [StoredWorkoutLog]) {
        self.init()
        let completedSessionIDs = Set(logs.filter { $0.completedAt != nil }.map(\.sessionId))
        plans = storedPlans.map { WorkoutsPlan(stored: $0, completedSessionIDs: completedSessionIDs) }
        if let first = plans.first {
            activePlanID = first.id
        }
    }
}

private extension WorkoutsPlan {

    init(stored: StoredPlan, completedSessionIDs: Set<UUID>) {
        let ordered = stored.orderedSessions
        var todayAssigned = false

        let sessions = ordered.map { session -> WorkoutsSession in
            let status: SessionStatus
            if completedSessionIDs.contains(session.id) {
                status = .done
            } else if !todayAssigned {
                todayAssigned = true
                status = .today
            } else {
                status = .upcoming
            }
            return WorkoutsSession(
                id: session.id,
                number: session.sessionNumber,
                name: session.name ?? "Training \(session.sessionNumber)",
                focus: session.focus,
                exercises: session.exercises.count,
                minutes: session.estimatedDurationMinutes,
                status: status
            )
        }

        let savedDay = stored.savedAt.formatted(.dateTime.month(.abbreviated).day())
        self.init(
            id: stored.id,
            name: stored.name ?? stored.splitType,
            meta: "\(ordered.count) sessions · since \(savedDay)",
            sessions: sessions
        )
    }
}
