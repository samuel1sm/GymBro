import SwiftUI

/// Screen 08 — Profile & Settings. Grouped iOS list on AppBackground.
/// Preferences, personal data summary, app settings. Tab 5 (Profile).
struct ProfileSettingsView: View {
    @Environment(\.coordinator) private var coordinator
    @Environment(\.userStore) private var userStore
    @Environment(\.appSettingsStore) private var appSettingsStore

    @State private var viewModel = ProfileSettingsViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        ScrollView {
            VStack(spacing: 0) {
                GBNavBar(title: "Profile")

                    ProfileSummaryCard(state: viewModel.state)

                    SettingsGroup(title: "Training Preferences") {
                        SettingsRow(label: "Goals", value: viewModel.state.goalsDisplay, showsChevron: true, isFirst: true)
                        SettingsRow(label: "Equipment", value: viewModel.state.equipmentDisplay, showsChevron: true)
                        SettingsRow(label: "Injuries", value: viewModel.state.injuries, showsChevron: true)
                    }

                    SettingsGroup(title: "Schedule") {
                        SettingsRow(label: "Days per week", value: "\(viewModel.state.daysPerWeek)", isFirst: true)
                        SettingsRow(label: "Session duration", value: "\(viewModel.state.sessionMinutes) min")
                        SettingsRow(label: "Preferred split", value: viewModel.state.preferredSplit)
                        SettingsRow(label: "Training days", value: viewModel.state.trainingDaysDisplay)
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

                    RedoSetupSection {
                        viewModel.redoSetup(popToRoot: coordinator.popToRoot)
                    }
                }
            }
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.load(from: userStore, settings: appSettingsStore)
        }
        .onChange(of: viewModel.state.appSettings) {
            viewModel.saveSettings(to: appSettingsStore)
        }
    }
}

// MARK: - Preview

#Preview {
    RouterView {
        ProfileSettingsView()
    }
}
