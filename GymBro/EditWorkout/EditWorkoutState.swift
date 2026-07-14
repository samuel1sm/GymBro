import Foundation

/// Identity of the session being edited — where Save writes back. Flows not
/// wired to a saved plan push the editor without one and edits stay local.
struct EditWorkoutContext: Hashable {
    let planId: UUID
    let sessionId: UUID
}

// MARK: - Models

/// A single exercise inside the session being edited.
///
/// `reps` and `rest` are free text so ranges ("6–8") and units ("120s") survive
/// inline editing — matching the Edit Workout design's text fields. `sets` stays
/// numeric because it is driven by a stepper.
struct EditExercise: Identifiable, Hashable {
    /// Matches `StoredExercise.id` when loaded from a saved plan, so saves
    /// write back to the same rows.
    var id: UUID = UUID()
    var name: String
    var muscles: String
    var sets: Int
    var reps: String
    var rest: String
}

/// The single training session presented by the editor.
struct EditWorkoutSession: Hashable {
    var name: String
    var focus: String
    var exercises: [EditExercise]
}

// MARK: - State

/// Backing state for the Edit Workout screen — one Push session seeded to match
/// the design handoff.
struct EditWorkoutState {
    var session: EditWorkoutSession = EditWorkoutState.seed

    /// The focus options offered by the focus picker sheet.
    static let focusOptions = ["Push", "Pull", "Legs", "Upper", "Lower", "Full body"]

    static let seed = EditWorkoutSession(
        name: "Training 1",
        focus: "Push",
        exercises: [
            .init(name: "Barbell Bench Press",        muscles: "Chest · Front Delts", sets: 4, reps: "6–8",   rest: "120s"),
            .init(name: "Incline Dumbbell Press",     muscles: "Upper Chest",         sets: 3, reps: "8–10",  rest: "90s"),
            .init(name: "Cable Fly",                  muscles: "Chest",               sets: 3, reps: "12–15", rest: "60s"),
            .init(name: "Overhead Triceps Extension", muscles: "Triceps",             sets: 3, reps: "10–12", rest: "60s"),
            .init(name: "Triceps Pushdown",           muscles: "Triceps",             sets: 3, reps: "12–15", rest: "45s"),
        ]
    )
}

// MARK: - Duration estimate

extension EditWorkoutSession {
    /// Rough live duration estimate in minutes — mirrors the design's heuristic:
    /// each set costs its rest plus ~50s of work.
    var estimatedMinutes: Int {
        let totalSeconds = exercises.reduce(0) { acc, exercise in
            let rest = Int(exercise.rest.filter(\.isNumber)) ?? 60
            return acc + exercise.sets * (rest + 50)
        }
        return Int((Double(totalSeconds) / 60).rounded())
    }
}
