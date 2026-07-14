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
    var selectedSession: WorkoutsSession?

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

    /// Replaces the state with the persisted plan library, if any plans have
    /// been saved. The selected plan survives reloads while it still exists.
    func load(from store: UserStore) {
        guard
            let user = try? store.loadUser(),
            let storedPlans = try? store.loadSavedPlans(for: user),
            !storedPlans.isEmpty
        else { return }

        let logs = (try? store.loadLogs(for: user)) ?? []
        let previousActiveID = state.activePlanID
        state = WorkoutsState(storedPlans: storedPlans, logs: logs)
        if state.plans.contains(where: { $0.id == previousActiveID }) {
            state.activePlanID = previousActiveID
        }
    }

    func selectSession(_ session: WorkoutsSession) {
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

    func activatePlan(_ plan: WorkoutsPlan) {
        state.activePlanID = plan.id
        isLibraryOpen = false
    }
}
