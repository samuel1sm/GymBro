import Foundation

/// Where a session sits in the week — drives the trailing status indicator.
enum SessionStatus {
    /// Already completed — Volt check + "Done".
    case done
    /// The session scheduled for today — Volt play + "Today".
    case today
    /// Not yet reached — a plain trailing chevron.
    case upcoming
}

/// One session in the active plan's session list.
struct WorkoutsSession: Identifiable {
    /// Matches `StoredSession.id` when loaded from persistence.
    let id: UUID
    /// The training number shown in the focus tile, e.g. 3.
    let number: Int
    /// Session name, e.g. "Training 3".
    let name: String
    /// Focus label from the plan, e.g. "Push" or "Full Body A" — drives the focus pill.
    let focus: String
    /// Exercise count.
    let exercises: Int
    /// Estimated duration in minutes.
    let minutes: Int
    let status: SessionStatus

    init(
        id: UUID = UUID(),
        number: Int,
        name: String,
        focus: String,
        exercises: Int,
        minutes: Int,
        status: SessionStatus
    ) {
        self.id = id
        self.number = number
        self.name = name
        self.focus = focus
        self.exercises = exercises
        self.minutes = minutes
        self.status = status
    }

    /// Metadata line, e.g. "7 exercises · 70 min".
    var metaLabel: String { "\(exercises) exercises · \(minutes) min" }
}

/// A saved plan in the plan-library selector, owning its session list.
struct WorkoutsPlan: Identifiable {
    /// Matches `StoredPlan.id` when loaded from persistence.
    let id: UUID
    let name: String
    /// Session count · start date, e.g. "5 sessions · since May 26".
    let meta: String
    let sessions: [WorkoutsSession]

    init(id: UUID = UUID(), name: String, meta: String, sessions: [WorkoutsSession] = []) {
        self.id = id
        self.name = name
        self.meta = meta
        self.sessions = sessions
    }
}

/// Screen 10 — Workouts (Tab 2).
///
/// All sessions in the active plan. Tapping a session opens a compact action
/// sheet (Start / Edit); the plan selector opens the saved-plans library — the
/// same destination as Statistics' "View all plans". The placeholder plans
/// below keep previews working; `WorkoutsViewModel.load(from:)` replaces them
/// with the persisted library.
struct WorkoutsState {

    var plans: [WorkoutsPlan] = [
        WorkoutsPlan(
            name: "5-Day PPL Split",
            meta: "5 sessions · since May 26",
            sessions: [
                WorkoutsSession(number: 1, name: "Training 1", focus: "Push", exercises: 6, minutes: 60, status: .done),
                WorkoutsSession(number: 2, name: "Training 2", focus: "Pull", exercises: 6, minutes: 65, status: .done),
                WorkoutsSession(number: 3, name: "Training 3", focus: "Legs", exercises: 7, minutes: 70, status: .today),
                WorkoutsSession(number: 4, name: "Training 4", focus: "Push", exercises: 6, minutes: 55, status: .upcoming),
                WorkoutsSession(number: 5, name: "Training 5", focus: "Pull", exercises: 6, minutes: 60, status: .upcoming),
            ]
        ),
        WorkoutsPlan(
            name: "Upper / Lower",
            meta: "4 sessions · since Apr 2",
            sessions: [
                WorkoutsSession(number: 1, name: "Training 1", focus: "Upper Body", exercises: 6, minutes: 60, status: .today),
                WorkoutsSession(number: 2, name: "Training 2", focus: "Lower Body", exercises: 5, minutes: 55, status: .upcoming),
                WorkoutsSession(number: 3, name: "Training 3", focus: "Upper Body", exercises: 6, minutes: 60, status: .upcoming),
                WorkoutsSession(number: 4, name: "Training 4", focus: "Lower Body", exercises: 5, minutes: 55, status: .upcoming),
            ]
        ),
        WorkoutsPlan(
            name: "Full Body",
            meta: "3 sessions · since Mar 1",
            sessions: [
                WorkoutsSession(number: 1, name: "Training 1", focus: "Full Body A", exercises: 5, minutes: 50, status: .today),
                WorkoutsSession(number: 2, name: "Training 2", focus: "Full Body B", exercises: 5, minutes: 50, status: .upcoming),
                WorkoutsSession(number: 3, name: "Training 3", focus: "Full Body A", exercises: 5, minutes: 50, status: .upcoming),
            ]
        ),
    ]

    /// The plan currently active — its name shows in the selector, and it is
    /// marked "Active" in the library. Defaults to the first plan.
    var activePlanID: WorkoutsPlan.ID

    /// The active plan's sessions.
    var sessions: [WorkoutsSession] {
        plans.first { $0.id == activePlanID }?.sessions ?? []
    }

    init() {
        activePlanID = plans.first!.id
    }
}
