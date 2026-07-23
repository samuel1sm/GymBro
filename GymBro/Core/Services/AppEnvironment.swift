import SwiftUI

/// Environment-based dependency injection. `GymBroApp` overrides `userStore`
/// with the on-disk SwiftData store; the remaining defaults keep previews and
/// tests working (in-memory stores; auth talks to the real backend).

private struct UserStoreKey: EnvironmentKey {
    static let defaultValue: UserStore = try! InMemoryUserStore()
}

private struct AccountServiceKey: EnvironmentKey {
    static let defaultValue: AccountService = SupabaseAccountService()
}

private struct PendingPlanStoreKey: EnvironmentKey {
    static let defaultValue = PendingPlanStore()
}

private struct AppSettingsStoreKey: EnvironmentKey {
    static let defaultValue: AppSettingsStore = InMemoryAppSettingsStore()
}

extension EnvironmentValues {
    var userStore: UserStore {
        get { self[UserStoreKey.self] }
        set { self[UserStoreKey.self] = newValue }
    }

    var accountService: AccountService {
        get { self[AccountServiceKey.self] }
        set { self[AccountServiceKey.self] = newValue }
    }

    var pendingPlanStore: PendingPlanStore {
        get { self[PendingPlanStoreKey.self] }
        set { self[PendingPlanStoreKey.self] = newValue }
    }

    var appSettingsStore: AppSettingsStore {
        get { self[AppSettingsStoreKey.self] }
        set { self[AppSettingsStoreKey.self] = newValue }
    }
}
