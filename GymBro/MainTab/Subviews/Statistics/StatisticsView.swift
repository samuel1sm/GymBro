import SwiftUI

/// Screen 09 — Statistics. Progress & analytics, split off from Home: weekly
/// volume trend, personal records, muscle frequency, and plan history in a single
/// scrollable view. Tab 3 (Stats) in the bottom tab bar.
struct StatisticsView: View {
    @Environment(\.userStore) private var userStore

    @State private var viewModel = StatisticsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ScreenTitleHeader(title: "Statistics", size: 22)
                    .padding(.bottom, 4)

                WeeklyVolumeCard(
                    points: viewModel.state.weeklyVolume,
                    currentVolumeLabel: viewModel.currentVolumeLabel,
                    trendPercent: viewModel.state.volumeTrendPercent
                )
                .padding(.horizontal, 20)
                .padding(.top, 24)

                PersonalRecordsSection(records: viewModel.state.personalRecords)
                    .padding(.top, 28)

                MuscleFrequencySection(muscles: viewModel.state.muscleGroups)
                    .padding(.top, 28)

                PlanHistorySection(plans: viewModel.state.plans)
                    .padding(.top, 28)
            }
            .padding(.bottom, 20)
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
        StatisticsView()
    }
}
