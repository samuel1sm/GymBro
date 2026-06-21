import Foundation

/// The training focus of a session — drives the focus pill label.
enum SessionFocus: String {
    case push = "Push"
    case pull = "Pull"
    case legs = "Legs"

    var label: String { rawValue }
}

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
struct WorkoutSession: Identifiable {
    let id = UUID()
    /// The training number shown in the focus tile, e.g. 3.
    let number: Int
    /// Session name, e.g. "Training 3".
    let name: String
    let focus: SessionFocus
    /// Exercise count.
    let exercises: Int
    /// Estimated duration in minutes.
    let minutes: Int
    let status: SessionStatus

    /// Metadata line, e.g. "7 exercises · 70 min".
    var metaLabel: String { "\(exercises) exercises · \(minutes) min" }
}

/// A saved plan in the plan-library selector.
struct WorkoutPlan: Identifiable {
    let id = UUID()
    let name: String
    /// Session count · start date, e.g. "5 sessions · since May 26".
    let meta: String
}

/// Screen 10 — Workouts (Tab 2).
///
/// All sessions in the active plan. Tapping a session opens a compact action
/// sheet (Start / Edit); the plan selector opens the saved-plans library — the
/// same destination as Statistics' "View all plans".
struct WorkoutsState {

    // MARK: - Sessions

    var sessions: [WorkoutSession] = [
        WorkoutSession(number: 1, name: "Training 1", focus: .push, exercises: 6, minutes: 60, status: .done),
        WorkoutSession(number: 2, name: "Training 2", focus: .pull, exercises: 6, minutes: 65, status: .done),
        WorkoutSession(number: 3, name: "Training 3", focus: .legs, exercises: 7, minutes: 70, status: .today),
        WorkoutSession(number: 4, name: "Training 4", focus: .push, exercises: 6, minutes: 55, status: .upcoming),
        WorkoutSession(number: 5, name: "Training 5", focus: .pull, exercises: 6, minutes: 60, status: .upcoming),
    ]

    // MARK: - Plans

    var plans: [WorkoutPlan] = [
        WorkoutPlan(name: "5-Day PPL Split", meta: "5 sessions · since May 26"),
        WorkoutPlan(name: "Upper / Lower",   meta: "4 sessions · Apr 2"),
        WorkoutPlan(name: "Full Body",       meta: "3 sessions · Mar 1"),
    ]

    /// The plan currently active — its name shows in the selector, and it is
    /// marked "Active" in the library. Defaults to the first plan.
    var activePlanID: WorkoutPlan.ID

    init() {
        activePlanID = plans.first!.id
    }
}
