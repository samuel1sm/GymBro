import SwiftUI

/// Environment-based dependency injection. `GymBroApp` overrides `userStore`
/// with the on-disk SwiftData store; the defaults keep previews and tests
/// working against in-memory/mock implementations.

private struct UserStoreKey: EnvironmentKey {
    static let defaultValue: UserStore = try! InMemoryUserStore()
}

private struct AccountServiceKey: EnvironmentKey {
    static let defaultValue: AccountService = MockAccountService()
}

private struct PendingPlanStoreKey: EnvironmentKey {
    static let defaultValue = PendingPlanStore()
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
}
