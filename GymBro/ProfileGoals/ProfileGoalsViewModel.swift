import Foundation
import Observation

/// View model for the Profile & Goals flow.
///
/// Owns the current step and the accumulated profile answers
/// (`ProfileGoalsState`). The view is a thin projection of this
/// object via `@Bindable`.
@Observable
final class ProfileGoalsViewModel {

    // MARK: - State

    var step: Int = 1
    var state = ProfileGoalsState()
}
