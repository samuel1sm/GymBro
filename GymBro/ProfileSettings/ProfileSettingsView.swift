import SwiftUI

/// Screen 08 — Profile & Settings. Grouped iOS list on AppBackground.
/// Preferences, personal data summary, app settings. Tab 5 (Profile).
struct ProfileSettingsView: View {
    @Environment(\.coordinator) private var coordinator

    @State private var viewModel = ProfileSettingsViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    GBNavBar(title: "Profile")

                    ProfileSummaryCard(state: viewModel.state)

                    SettingsGroup(title: "Training Preferences") {
                        SettingsRow(label: "Goals", value: viewModel.state.goalsDisplay, showsChevron: true, isFirst: true)
                        SettingsRow(label: "Equipment", value: viewModel.state.equipment.rawValue, showsChevron: true)
                        SettingsRow(label: "Injuries", value: viewModel.state.injuries, showsChevron: true)
                    }

                    SettingsGroup(title: "Schedule") {
                        SettingsRow(label: "Days per week", value: "\(viewModel.state.daysPerWeek)", isFirst: true)
                        SettingsRow(label: "Session duration", value: "\(viewModel.state.sessionMinutes) min")
                        SettingsRow(label: "Preferred split", value: viewModel.state.preferredSplit)
                        SettingsRow(label: "Workout time", value: viewModel.state.workoutTime)
                    }

                    SettingsGroup(title: "App Settings") {
                        SettingsRow(label: "Units", isFirst: true) {
                            UnitsToggle(selection: $vm.state.weightUnit)
                        }
                        SettingsRow(label: "Notifications") {
                            GBSwitch(isOn: $vm.state.notificationsEnabled)
                        }
                        SettingsRow(label: "Rest timer sound") {
                            GBSwitch(isOn: $vm.state.restTimerSound)
                        }
                    }

                    SettingsGroup(title: "Plan Management") {
                        SettingsRow(label: "Saved Plans", showsChevron: true, isFirst: true)
                        SettingsRow(label: "Export Data", showsChevron: true)
                    }

                    redoSetup
                }
            }

            GBTabBar(activeTab: .profile)
        }
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Danger zone

    private var redoSetup: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                viewModel.redoSetup(popToRoot: coordinator.popToRoot)
            } label: {
                Text("Redo Setup")
                    .font(.plusJakartaSans(.semiBold, size: 15))
                    .foregroundStyle(.danger)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderDefault, lineWidth: 1))
            }
            .buttonStyle(.plain)

            Text("Resets your profile and preferences. Your workout history is kept.")
                .font(.plusJakartaSans(.regular, size: 12))
                .foregroundStyle(.labelTertiary)
                .lineSpacing(3)
                .padding(.horizontal, 4)
        }
        .padding(.horizontal, 20)
        .padding(.top, 32)
        .padding(.bottom, 28)
    }
}

// MARK: - Preview

#Preview {
    RouterView {
        ProfileSettingsView()
    }
}
