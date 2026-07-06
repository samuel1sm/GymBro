import Foundation
import Observation

/// View model for the Statistics screen.
///
/// Owns the progress-analytics data (weekly volume, personal records, muscle
/// frequency, plan history) and exposes formatted readouts. The view is a thin
/// projection of this object.
@Observable
final class StatisticsViewModel {

    var state: StatisticsState

    init(state: StatisticsState = StatisticsState()) {
        self.state = state
    }

    /// The headline weekly volume, grouped for the user's locale, e.g. "14,100".
    var currentVolumeLabel: String {
        state.currentVolumeKg.formatted()
    }
}
