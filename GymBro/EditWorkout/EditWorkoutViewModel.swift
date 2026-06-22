import Foundation
import Observation
import SwiftUI

/// View model for the Edit Workout screen.
///
/// Owns the edited session, the currently expanded exercise card, a dirty flag
/// (drives the discard-on-cancel flow) and the transient toast. Every mutation
/// routes through here so editing always flips `isDirty`.
@Observable
final class EditWorkoutViewModel {

    // MARK: - State

    var state = EditWorkoutState()

    /// The exercise whose inline sets/reps/rest editor is expanded, if any.
    var expandedExerciseID: EditExercise.ID? = nil

    /// Set the moment the user changes anything — gates the discard sheet.
    private(set) var isDirty = false

    var toastMessage: String? = nil

    // MARK: - Private

    private var toastTask: Task<Void, Never>? = nil

    // MARK: - Derived

    var session: EditWorkoutSession { state.session }

    // MARK: - Session edits

    func rename(_ name: String) {
        state.session.name = name
        markDirty()
    }

    func setFocus(_ focus: String) {
        guard state.session.focus != focus else { return }
        state.session.focus = focus
        markDirty()
    }

    // MARK: - Exercise edits

    func toggleExpanded(_ id: EditExercise.ID) {
        expandedExerciseID = (expandedExerciseID == id) ? nil : id
    }

    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        state.session.exercises.move(fromOffsets: source, toOffset: destination)
        markDirty()
    }

    func stepSets(id: EditExercise.ID, by delta: Int) {
        guard let index = indexOf(id) else { return }
        state.session.exercises[index].sets = max(1, state.session.exercises[index].sets + delta)
        markDirty()
    }

    func updateReps(id: EditExercise.ID, _ value: String) {
        guard let index = indexOf(id) else { return }
        state.session.exercises[index].reps = value
        markDirty()
    }

    func updateRest(id: EditExercise.ID, _ value: String) {
        guard let index = indexOf(id) else { return }
        state.session.exercises[index].rest = value
        markDirty()
    }

    func remove(id: EditExercise.ID) {
        state.session.exercises.removeAll { $0.id == id }
        if expandedExerciseID == id { expandedExerciseID = nil }
        markDirty()
        fireToast("Exercise removed")
    }

    // MARK: - Discard

    func discardChanges() {
        state = EditWorkoutState()
        expandedExerciseID = nil
        isDirty = false
    }

    // MARK: - Helpers

    private func indexOf(_ id: EditExercise.ID) -> Int? {
        state.session.exercises.firstIndex { $0.id == id }
    }

    private func markDirty() { isDirty = true }

    // MARK: - Toast

    func fireToast(_ message: String) {
        toastTask?.cancel()
        toastMessage = message
        toastTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 1_700_000_000)
            guard let self, !Task.isCancelled else { return }
            self.toastMessage = nil
        }
    }
}
