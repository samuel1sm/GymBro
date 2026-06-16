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
        switch Calendar.current.component(.hour, from: Date()) {
        case ..<12:  return "Good morning"
        case 12..<18: return "Good afternoon"
        default:     return "Good evening"
        }
    }

    /// Today's date as an uppercase header label, e.g. "FRIDAY, MAY 29".
    var dateLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date()).uppercased()
    }

    /// Starts today's session → Active Workout Session (Screen 06).
    func startWorkout(push: (Route) -> Void) {
        push(.activeSession)
    }
}
