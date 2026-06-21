import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: GBTab = .home

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(GBTab.home)
                    .toolbar(.hidden, for: .tabBar)

                WorkoutsView()
                    .tag(GBTab.workouts)
                    .toolbar(.hidden, for: .tabBar)

                StatisticsView()
                    .tag(GBTab.stats)
                    .toolbar(.hidden, for: .tabBar)

                ProfileSettingsView()
                    .tag(GBTab.profile)
                    .toolbar(.hidden, for: .tabBar)
            }

            GBTabBar(activeTab: selectedTab) { selectedTab = $0 }
        }
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Preview

#Preview {
    RouterView {
        MainTabView()
    }
}
