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

    /// Replaces the state with the persisted profile, if one exists, then
    /// overlays the saved app settings. Until the first save, the units
    /// default to the profile's stored unit system.
    func load(from store: UserStore, settings settingsStore: AppSettingsStore) {
        if let user = try? store.loadUser() {
            state = ProfileSettingsState(user: user)
        }
        if let saved = settingsStore.load() {
            state.appSettings = saved
        }
    }

    func saveSettings(to settingsStore: AppSettingsStore) {
        settingsStore.save(state.appSettings)
    }

    /// Resets profile and preferences, then re-triggers onboarding.
    /// Workout history is kept.
    func redoSetup(popToRoot: () -> Void) {
        state = ProfileSettingsState()
        popToRoot()
    }
}
