import Foundation

extension ActiveSessionState {

    /// Builds the session from a persisted `StoredSession`, so exercises keep
    /// their stored ids and logged sets reference real `StoredExercise` rows.
    init(stored: StoredSession) {
        self.init()
        split = stored.focus.uppercased()
        day = stored.sessionNumber
        exercises = stored.orderedExercises.map { ActiveSessionExercise(stored: $0) }
        logs = Array(repeating: [], count: exercises.count)
    }
}

private extension ActiveSessionExercise {

    /// Plans carry no target weight — `planKg` stays 0 and the weight input
    /// starts empty until the first set is logged.
    init(stored: StoredExercise) {
        self.init(
            id: stored.id,
            name: stored.name,
            subtitle: stored.equipment.displayLabel,
            muscles: stored.primaryMuscles.map(\.displayLabel),
            sets: stored.sets,
            repLo: stored.repsMin,
            repHi: stored.repsMax,
            planKg: 0,
            restSeconds: stored.restSeconds
        )
    }
}

private extension String {
    /// "cable_machine" → "Cable Machine" — display form of a stored raw value.
    var displayLabel: String {
        replacingOccurrences(of: "_", with: " ").capitalized
    }
}
