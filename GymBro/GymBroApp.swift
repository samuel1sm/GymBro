import SwiftUI
import SwiftData

@main
struct GymBroApp: App {


    private let modelContainer: ModelContainer
    private let userStore: UserStore
    private let pendingPlanStore = PendingPlanStore()

    init() {
        FontRegister.registerAll()

        do {
            let container = try PersistenceContainer.makeShared()
            modelContainer = container
            userStore = SwiftDataUserStore(context: ModelContext(container))
        } catch {
            fatalError("Failed to set up the SwiftData container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RouterView {
                LaunchView()
            }
            .environment(\.userStore, userStore)
            .environment(\.pendingPlanStore, pendingPlanStore)
        }
        .modelContainer(modelContainer)
    }
}

// MARK: - Login

/// Resolves the post-login destination: a saved `StoredUser` routes the
/// returning-user flow, `nil` routes new-user onboarding.
enum LoginFlow {

    enum Destination {
        case returningUser(StoredUser, savedPlans: [StoredPlan])
        case newUser
    }

    static func resolve(using store: UserStore) throws -> Destination {
        guard let user = try store.loadUser() else {
            return .newUser
        }
        let plans = try store.loadSavedPlans(for: user)
        return .returningUser(user, savedPlans: plans)
    }
}
