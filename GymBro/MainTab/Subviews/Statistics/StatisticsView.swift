import SwiftUI

/// Screen 09 — Statistics. Progress & analytics, split off from Home: weekly
/// volume trend, personal records, muscle frequency, and plan history in a single
/// scrollable view. Tab 3 (Stats) in the bottom tab bar.
struct StatisticsView: View {
    @State private var viewModel = StatisticsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header

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
    }

    private var header: some View {
        Text("Statistics")
            .font(.barlowCondensed(.bold, size: 22))
            .kerning(-0.5)
            .foregroundStyle(.labelPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 4)
    }
}

// MARK: - Preview

#Preview {
    RouterView {
        StatisticsView()
    }
}
