import SwiftUI
import Observation

@Observable
final class Coordinator {
    var path = NavigationPath()

    /// True only on the environment fallback instance — navigating through it
    /// means the view sits outside `RouterView`, so it goes nowhere.
    @ObservationIgnored private let isEnvironmentFallback: Bool

    init() {
        isEnvironmentFallback = false
    }

    fileprivate init(environmentFallback: Bool) {
        isEnvironmentFallback = environmentFallback
    }

    func push(_ route: Route) {
        assertInjected()
        path.append(route)
    }

    /// One-shot toast for the screen revealed by the next pop — set it before
    /// popping, and the destination consumes it on appear.
    var pendingToast: String?

    func consumePendingToast() -> String? {
        defer { pendingToast = nil }
        return pendingToast
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func pop(count: Int) {
        path.removeLast(min(count, path.count))
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    /// Clears the stack and makes `route` its only destination — the screens
    /// underneath (auth, onboarding) can't be navigated back to.
    func replaceRoot(_ route: Route) {
        assertInjected()
        path = NavigationPath([route])
    }

    private func assertInjected() {
        assert(
            !isEnvironmentFallback,
            "No Coordinator in the environment — wrap the hierarchy (previews included) in RouterView."
        )
    }
}

// MARK: - Environment

private struct CoordinatorKey: EnvironmentKey {
    // SwiftUI reads this while *injecting* the real coordinator (the key-path
    // setter reads before writing), so the default itself must stay benign;
    // the fallback instance asserts if anything actually navigates through it.
    static let defaultValue = Coordinator(environmentFallback: true)
}

extension EnvironmentValues {
    var coordinator: Coordinator {
        get { self[CoordinatorKey.self] }
        set { self[CoordinatorKey.self] = newValue }
    }
}
