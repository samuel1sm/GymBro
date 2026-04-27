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
                        OnboardingView()
                    case .accountInformation:
                        OnboardingView()
                    }
                }
        }
        .environment(\.coordinator, coordinator)
    }
}
