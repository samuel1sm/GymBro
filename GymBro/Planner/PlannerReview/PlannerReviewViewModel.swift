import Foundation
import Observation
import SwiftUI

/// View model for the Planner Review screen.
///
/// Owns the weekly plan under review (`PlannerReviewState`), the active
/// session tab, the expanded exercise editor and the transient toast. The
/// view is a thin projection of this object via `@Bindable`.
@Observable
final class PlannerReviewViewModel {

    // MARK: - State

    var state = PlannerReviewState(plan: .reviewSeed)
    var toastMessage: String? { toast.message }

    var activeIndex: Int = 0 {
        didSet { expandedExerciseID = nil }
    }

    /// The exercise whose inline sets/reps/rest editor is expanded, if any.
    var expandedExerciseID: PlannerExercise.ID? = nil

    // MARK: - Private

    private var hasLoadedPendingPlan = false
    private let toast = ToastPresenter()

    // MARK: - Derived

    var activeSlot: PlannerTrainingSlot {
        state.slots[min(activeIndex, state.slots.count - 1)]
    }

    var activeExercises: [PlannerExercise] { activeSlot.exercises }

    // MARK: - Loading / saving

    /// Replaces the seeded state with the stashed generated plan. Runs once so
    /// re-appearing (e.g. after a push/pop) doesn't wipe in-progress edits.
    func loadPendingPlan(_ plan: AIPlan.WorkoutPlan?) {
        guard !hasLoadedPendingPlan else { return }
        hasLoadedPendingPlan = true
        guard let plan, !plan.sessions.isEmpty else { return }
        state = PlannerReviewState(plan: plan)
        activeIndex = 0
    }

    func buildPlan() -> AIPlan.WorkoutPlan { state.buildPlan() }

    // MARK: - Exercise edits

    func toggleExpanded(_ id: PlannerExercise.ID) {
        expandedExerciseID = (expandedExerciseID == id) ? nil : id
    }

    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        guard state.slots.indices.contains(activeIndex) else { return }
        state.slots[activeIndex].exercises.move(fromOffsets: source, toOffset: destination)
    }

    func stepSets(id: PlannerExercise.ID, by delta: Int) {
        guard let index = indexOf(id) else { return }
        let sets = state.slots[activeIndex].exercises[index].sets
        state.slots[activeIndex].exercises[index].sets = max(1, sets + delta)
    }

    func updateReps(id: PlannerExercise.ID, _ value: String) {
        guard let index = indexOf(id) else { return }
        state.slots[activeIndex].exercises[index].repsText = value
    }

    func updateRest(id: PlannerExercise.ID, _ value: String) {
        guard let index = indexOf(id) else { return }
        state.slots[activeIndex].exercises[index].restText = value
    }

    func remove(_ exercise: PlannerExercise) {
        guard state.slots.indices.contains(activeIndex) else { return }
        state.slots[activeIndex].exercises.removeAll { $0.id == exercise.id }
        if expandedExerciseID == exercise.id { expandedExerciseID = nil }
    }

    // MARK: - Helpers

    private func indexOf(_ id: PlannerExercise.ID) -> Int? {
        guard state.slots.indices.contains(activeIndex) else { return nil }
        return state.slots[activeIndex].exercises.firstIndex { $0.id == id }
    }

    // MARK: - Toast

    func fireToast(_ message: String) {
        toast.fire(message)
    }
}
