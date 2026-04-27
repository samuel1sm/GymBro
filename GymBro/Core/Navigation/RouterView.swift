import SwiftUI

struct RouterView<Root: View>: View {
    @State private var coordinator = Coordinator()
    private let root: Root

    init(@ViewBuilder root: () -> Root) {
        self.root = root()
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            root
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .firstOnboarding:
                        FirstOnboardingView()
                    case .secondOnboarding:
                        FirstOnboardingView()
                    }
                }
        }
        .environment(\.coordinator, coordinator)
    }
}
