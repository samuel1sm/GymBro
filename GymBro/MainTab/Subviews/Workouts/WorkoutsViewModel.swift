import Foundation
import Observation

/// View model for the Workouts screen.
///
/// Owns the session list and saved plans, plus the transient UI state for the
/// two bottom sheets: the per-session action sheet (Start / Edit) and the
/// plan-library selector. The view is a thin projection of this object.
@Observable
final class WorkoutsViewModel {

    var state: WorkoutsState

    /// The session whose action sheet is open, if any.
    var selectedSession: WorkoutSession?

    /// Whether the plan-library selector is open.
    var isLibraryOpen = false

    init(state: WorkoutsState = WorkoutsState()) {
        self.state = state
    }

    // MARK: - Derived

    /// The active plan's display name, shown in the selector row.
    var activePlanName: String {
        state.plans.first { $0.id == state.activePlanID }?.name ?? ""
    }

    // MARK: - Intents

    func selectSession(_ session: WorkoutSession) {
        selectedSession = session
    }

    func dismissSession() {
        selectedSession = nil
    }

    func openLibrary() {
        isLibraryOpen = true
    }

    func closeLibrary() {
        isLibraryOpen = false
    }

    func activatePlan(_ plan: WorkoutPlan) {
        state.activePlanID = plan.id
        isLibraryOpen = false
    }
}
