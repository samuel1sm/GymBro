import Foundation

extension EditWorkoutState {

    /// Builds the editor state from a persisted `StoredSession`, so exercises
    /// keep their stored ids and Save writes back to the same rows.
    init(stored: StoredSession) {
        self.init()
        session = EditWorkoutSession(stored: stored)
    }
}

extension EditWorkoutSession {

    init(stored: StoredSession) {
        self.init(
            name: stored.name ?? "Training \(stored.sessionNumber)",
            focus: stored.focus,
            exercises: stored.orderedExercises.map { EditExercise(stored: $0) }
        )
    }

    /// The edited prescriptions in display order, ready for
    /// `UserStore.updateSession`. Free-text reps/rest without digits map to nil
    /// and leave the stored values untouched.
    var exerciseEdits: [SessionExerciseEdit] {
        exercises.map { exercise in
            let reps = exercise.reps.integerRuns
            return SessionExerciseEdit(
                id: exercise.id,
                sets: exercise.sets,
                repsMin: reps.first,
                repsMax: reps.last,
                restSeconds: Int(exercise.rest.filter(\.isNumber))
            )
        }
    }
}

private extension EditExercise {

    init(stored: StoredExercise) {
        self.init(
            id: stored.id,
            name: stored.name,
            muscles: stored.primaryMuscles.map(\.displayLabel).joined(separator: " · "),
            sets: stored.sets,
            reps: stored.repsMin == stored.repsMax ? "\(stored.repsMin)" : "\(stored.repsMin)–\(stored.repsMax)",
            rest: "\(stored.restSeconds)s"
        )
    }
}

private extension String {
    /// "cable_machine" → "Cable Machine" — display form of a stored raw value.
    var displayLabel: String {
        replacingOccurrences(of: "_", with: " ").capitalized
    }

    /// The runs of digits in the text, e.g. "6–8" → [6, 8].
    var integerRuns: [Int] {
        split(whereSeparator: { !$0.isNumber }).compactMap { Int($0) }
    }
}
