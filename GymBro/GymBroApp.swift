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
            // Share the container's mainContext so future @Query/@Environment
            // consumers observe the same context the store writes through.
            userStore = SwiftDataUserStore(context: container.mainContext)
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

/// Resolves where sign-in lands: Home when the account already has a saved
/// plan, otherwise Planner Review so the user still reviews (and saves) one —
/// pending or freshly generated. Store errors fall back to the review screen,
/// which can always save.
enum LoginFlow {

    static func postSignInRoute(using store: UserStore) -> Route {
        guard let user = try? store.loadUser(),
              let plans = try? store.loadSavedPlans(for: user),
              !plans.isEmpty
        else { return .plannerReview }
        return .main
    }
}
