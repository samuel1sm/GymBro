import Foundation

/// App-only preferences that live in `UserDefaults` — they belong to the
/// device, not the SwiftData profile.
struct AppSettings: Equatable {
    var weightUnit: WeightUnit = .kg
    var notificationsEnabled: Bool = true
    var restTimerSound: Bool = true
}

protocol AppSettingsStore {
    /// `nil` until the first save, so callers can seed defaults from elsewhere
    /// (e.g. units from the stored profile).
    func load() -> AppSettings?
    func save(_ settings: AppSettings)
}

struct UserDefaultsAppSettingsStore: AppSettingsStore {

    private enum Key {
        static let weightUnit = "appSettings.weightUnit"
        static let notificationsEnabled = "appSettings.notificationsEnabled"
        static let restTimerSound = "appSettings.restTimerSound"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> AppSettings? {
        guard let rawUnit = defaults.string(forKey: Key.weightUnit),
              let unit = WeightUnit(rawValue: rawUnit)
        else { return nil }
        return AppSettings(
            weightUnit: unit,
            notificationsEnabled: defaults.bool(forKey: Key.notificationsEnabled),
            restTimerSound: defaults.bool(forKey: Key.restTimerSound)
        )
    }

    func save(_ settings: AppSettings) {
        defaults.set(settings.weightUnit.rawValue, forKey: Key.weightUnit)
        defaults.set(settings.notificationsEnabled, forKey: Key.notificationsEnabled)
        defaults.set(settings.restTimerSound, forKey: Key.restTimerSound)
    }
}

/// `AppSettingsStore` for previews and tests; nothing persists.
final class InMemoryAppSettingsStore: AppSettingsStore {

    private var settings: AppSettings?

    func load() -> AppSettings? {
        settings
    }

    func save(_ settings: AppSettings) {
        self.settings = settings
    }
}
