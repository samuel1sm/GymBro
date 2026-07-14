import Foundation
import Observation

/// View model for the Home screen.
///
/// Owns the launch dashboard data (today's session, weekly progress) and derives
/// the time-aware greeting and date label shown in the header. The view is a thin
/// projection of this object.
@Observable
final class HomeViewModel {

    var state: HomeState

    init(state: HomeState = HomeState()) {
        self.state = state
    }

    /// Time-aware greeting — morning before noon, afternoon before 18:00, else evening.
    var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case ..<12:   String(localized: "Good morning")
        case 12..<18: String(localized: "Good afternoon")
        default:      String(localized: "Good evening")
        }
    }

    /// Today's date as an uppercase header label, e.g. "FRIDAY, MAY 29".
    var dateLabel: String {
        Date.now.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()).uppercased()
    }

    /// Replaces the state with the persisted profile, plan library and logs.
    func load(from store: UserStore) {
        guard let user = try? store.loadUser() else { return }
        let plans = (try? store.loadSavedPlans(for: user)) ?? []
        let logs = (try? store.loadLogs(for: user)) ?? []
        state = HomeState(user: user, plans: plans, logs: logs)
    }

    /// Starts today's session → Active Workout Session (Screen 06).
    func startWorkout(push: (Route) -> Void) {
        push(.activeSession(state.activeSessionContext))
    }
}
