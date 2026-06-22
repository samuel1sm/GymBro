import Foundation
import Observation
import SwiftUI

/// View model for the Planner Review screen.
///
/// Owns the weekly plan (`PlannerReviewState`), the active session tab,
/// the opened exercise card and the transient toast. The view is a thin
/// projection of this object via `@Bindable`.
@Observable
final class PlannerReviewViewModel {

    // MARK: - State

    var state = PlannerReviewState()
    var toastMessage: String? = nil

    var activeIndex: Int = 0

    // MARK: - Private

    private var toastTask: Task<Void, Never>? = nil

    // MARK: - Derived

    var activeSlot: PlannerTrainingSlot { state.slots[activeIndex] }
    var activeExercises: [PlannerExercise] { activeSlot.exercises }

    // MARK: - Actions

    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        guard state.slots.indices.contains(activeIndex) else { return }
        state.slots[activeIndex].exercises.move(fromOffsets: source, toOffset: destination)
    }

    func remove(_ exercise: PlannerExercise) {
        guard state.slots.indices.contains(activeIndex) else { return }
        state.slots[activeIndex].exercises.removeAll { $0.id == exercise.id }
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
