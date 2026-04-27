import SwiftUI
import Observation

@Observable
final class Coordinator {
    var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

// MARK: - Environment

private struct CoordinatorKey: EnvironmentKey {
    static let defaultValue = Coordinator()
}

extension EnvironmentValues {
    var coordinator: Coordinator {
        get { self[CoordinatorKey.self] }
        set { self[CoordinatorKey.self] = newValue }
    }
}
