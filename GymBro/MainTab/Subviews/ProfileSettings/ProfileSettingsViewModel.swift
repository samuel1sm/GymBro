import Foundation
import Observation

/// View model for the Profile & Settings screen.
///
/// Owns the profile summary data and the mutable app settings (units,
/// notifications, rest timer sound). The view is a thin projection of this
/// object via `@Bindable`.
@Observable
final class ProfileSettingsViewModel {

    var state: ProfileSettingsState

    init(state: ProfileSettingsState = ProfileSettingsState()) {
        self.state = state
    }

    /// Resets profile and preferences, then re-triggers onboarding.
    /// Workout history is kept.
    func redoSetup(popToRoot: () -> Void) {
        state = ProfileSettingsState()
        popToRoot()
    }
}
