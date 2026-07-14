import SwiftUI

/// Screen 07 — Home. Action-focused launch view: greeting, today's session,
/// this week. Tab 1 in the bottom tab bar.
struct HomeView: View {
    @Environment(\.coordinator) private var coordinator
    @Environment(\.userStore) private var userStore

    @State private var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HomeHeader(
                    dateLabel: viewModel.dateLabel,
                    greeting: viewModel.greeting,
                    name: viewModel.state.name,
                    streak: viewModel.state.streak
                )

                TodaySessionCard(
                    isRestDay: viewModel.state.isRestDay,
                    title: viewModel.state.sessionTitle,
                    detail: viewModel.state.sessionDetail,
                    onStart: { viewModel.startWorkout(push: coordinator.push) }
                )

                WeekStrip(
                    week: viewModel.state.week,
                    month: viewModel.state.month,
                    monthLabel: viewModel.state.monthLabel,
                    doneCount: viewModel.state.doneCount,
                    plannedCount: viewModel.state.plannedCount,
                    monthDoneCount: viewModel.state.monthDoneCount,
                    monthPlannedCount: viewModel.state.monthPlannedCount
                )
            }
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.load(from: userStore)
        }
    }
}

// MARK: - Preview

#Preview {
    RouterView {
        HomeView()
    }
}
