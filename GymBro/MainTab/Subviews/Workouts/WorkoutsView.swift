import SwiftUI

/// Screen 10 — Workouts (Tab 2).
///
/// The active plan's session list. Tapping a session opens a compact action
/// sheet (Start / Edit); the plan selector opens the saved-plans library. Lives
/// inside `MainTabView`, which owns the bottom tab bar.
struct WorkoutsView: View {
    @Environment(\.coordinator) private var coordinator
    @State private var viewModel = WorkoutsViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ScreenTitleHeader(title: "My Workouts")

                PlanSelectorRow(planName: viewModel.activePlanName) {
                    viewModel.openLibrary()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                SessionsSection(sessions: viewModel.state.sessions) { session in
                    viewModel.selectSession(session)
                }
                .padding(.top, 26)
            }
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $vm.selectedSession) { session in
            SessionActionSheet(
                session: session,
                onStart: {
                    viewModel.dismissSession()
                    coordinator.push(.activeSession)
                },
                onEdit: {
                    viewModel.dismissSession()
                    coordinator.push(.editWorkout)
                }
            )
            .presentationDetents([.height(280)])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(24)
            .presentationBackground(Color.surfacePrimary)
        }
        .sheet(isPresented: $vm.isLibraryOpen) {
            PlanLibrarySheet(
                plans: viewModel.state.plans,
                activePlanID: viewModel.state.activePlanID,
                onPick: { viewModel.activatePlan($0) }
            )
            .presentationDetents([.height(400)])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(24)
            .presentationBackground(Color.surfacePrimary)
        }
    }

}

// MARK: - Preview

#Preview {
    RouterView {
        WorkoutsView()
    }
}
