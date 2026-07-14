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

    var toastMessage: String? { toast.message }

    // MARK: - Private

    private let toast = ToastPresenter()

    /// The plan/session this editor writes back to — nil when launched from a
    /// flow that isn't wired to a saved plan, in which case edits stay local.
    private let context: EditWorkoutContext?

    // MARK: - Init

    init(context: EditWorkoutContext? = nil) {
        self.context = context
    }

    // MARK: - Derived

    var session: EditWorkoutSession { state.session }

    // MARK: - Persistence

    /// Replaces the placeholder session with the stored session named by the
    /// context. No-op once edits are in flight or when the context is missing
    /// from the library.
    func load(from store: UserStore) {
        guard !isDirty, let stored = storedSession(in: store) else { return }
        state = EditWorkoutState(stored: stored)
    }

    /// Writes the edited session back to the store — the Save action.
    func save(to store: UserStore) {
        guard let stored = storedSession(in: store) else { return }
        let name = session.name.trimmingCharacters(in: .whitespaces)
        try? store.updateSession(
            stored,
            name: name.isEmpty ? nil : name,
            focus: session.focus,
            estimatedDurationMinutes: session.estimatedMinutes,
            exercises: session.exerciseEdits
        )
    }

    private func storedSession(in store: UserStore) -> StoredSession? {
        guard
            let context,
            let user = try? store.loadUser(),
            let plans = try? store.loadSavedPlans(for: user)
        else { return nil }
        return plans.first { $0.id == context.planId }?
            .orderedSessions.first { $0.id == context.sessionId }
    }

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

    // MARK: - Helpers

    private func indexOf(_ id: EditExercise.ID) -> Int? {
        state.session.exercises.firstIndex { $0.id == id }
    }

    private func markDirty() { isDirty = true }

    // MARK: - Toast

    func fireToast(_ message: String) {
        toast.fire(message)
    }
}
