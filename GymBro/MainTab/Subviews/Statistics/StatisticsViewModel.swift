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

    /// The headline weekly volume, grouped for display, e.g. "14,100".
    var currentVolumeLabel: String {
        Self.groupedFormatter.string(from: NSNumber(value: state.currentVolumeKg))
            ?? "\(state.currentVolumeKg)"
    }

    private static let groupedFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
}
