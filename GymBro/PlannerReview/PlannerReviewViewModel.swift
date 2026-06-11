import Foundation
import Observation

/// View model for the Planner Review screen.
///
/// Owns the weekly plan (`PlannerReviewState`), the active session tab,
/// the opened exercise card and the transient toast. The view is a thin
/// projection of this object via `@Bindable`.
@Observable
final class PlannerReviewViewModel {

    // MARK: - State

    var state = PlannerReviewState()
    var openedExerciseID: PlannerExercise.ID? = nil
    var toastMessage: String? = nil

    var activeIndex: Int = 0 {
        didSet { openedExerciseID = nil }
    }

    // MARK: - Private

    private var toastTask: Task<Void, Never>? = nil

    // MARK: - Derived

    var activeSlot: PlannerTrainingSlot { state.slots[activeIndex] }
    var activeExercises: [PlannerExercise] { activeSlot.exercises }

    // MARK: - Actions

    func openExercise(_ id: PlannerExercise.ID) {
        openedExerciseID = id
    }

    func closeExercise(_ id: PlannerExercise.ID) {
        if openedExerciseID == id { openedExerciseID = nil }
    }

    func move(from index: Int, by delta: Int) {
        let target = index + delta
        guard state.slots.indices.contains(activeIndex) else { return }
        let exercises = state.slots[activeIndex].exercises
        guard exercises.indices.contains(index), exercises.indices.contains(target) else { return }
        state.slots[activeIndex].exercises.swapAt(index, target)
    }

    func remove(at index: Int) {
        guard state.slots.indices.contains(activeIndex),
              state.slots[activeIndex].exercises.indices.contains(index) else { return }
        state.slots[activeIndex].exercises.remove(at: index)
    }

    // MARK: - Toast

    func fireToast(_ message: String) {
        toastTask?.cancel()
        toastMessage = message
        toastTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 1_800_000_000)
            guard let self, !Task.isCancelled else { return }
            self.toastMessage = nil
        }
    }
}
