import SwiftUI

private let maxGoals = 3

private let dayOptions = [2, 3, 4, 5, 6]
private let durationOptions = [30, 45, 60, 90]

struct GoalsView: View {
    @Binding var state: ProfileGoalsState
    let onNext: () -> Void
    let onBack: () -> Void

    private var daysPerWeekIndex: Binding<Int> {
        Binding(
            get: { dayOptions.firstIndex(of: state.daysPerWeek) ?? 2 },
            set: {
                state.daysPerWeek = dayOptions[$0]
                trimPreferredDays()
            }
        )
    }

    /// Drops the later weekdays when the chosen day count shrinks below the selection.
    private func trimPreferredDays() {
        guard state.preferredDays.count > state.daysPerWeek else { return }
        let ordered = TrainingDay.allCases.filter(state.preferredDays.contains)
        state.preferredDays = Set(ordered.prefix(state.daysPerWeek))
    }

    private var durationIndex: Binding<Int> {
        Binding(
            get: { durationOptions.firstIndex(of: state.sessionDurationMinutes) ?? 2 },
            set: { state.sessionDurationMinutes = durationOptions[$0] }
        )
    }

    private func toggleDay(_ day: TrainingDay) {
        if state.preferredDays.contains(day) {
            state.preferredDays.remove(day)
        } else if state.preferredDays.count < state.daysPerWeek {
            state.preferredDays.insert(day)
        }
    }

    private func toggle(_ goal: FitnessGoal) {
        if let i = state.goals.firstIndex(of: goal) {
            state.goals.remove(at: i)
        } else if state.goals.count < maxGoals {
            state.goals.append(goal)
        }
    }

    var body: some View {
        ProfileFrame(
            step: .goals,
            title: "What are training goals?",
            subtitle: "Define your ideal training schedule",
            ctaDisabled: state.goals.isEmpty,
            onNext: onNext,
            onBack: onBack
        ) {
            VStack(alignment: .leading, spacing: 20) {
                Text("YOUR SCHEDULE")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .tracking(1.6)
                    .foregroundStyle(.labelTertiary)
                    .padding(.top, 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Days per week")
                        .font(.plusJakartaSans(.medium, size: 14))
                        .foregroundStyle(.labelSecondary)

                    SegmentedPicker(options: dayOptions.map(String.init), selectedIndex: daysPerWeekIndex)
                        .frame(height: 52)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Session length")
                        .font(.plusJakartaSans(.medium, size: 14))
                        .foregroundStyle(.labelSecondary)

                    SegmentedPicker(options: durationOptions.map { "\($0) min" }, selectedIndex: durationIndex)
                        .frame(height: 52)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Preferred training days")
                            .font(.plusJakartaSans(.medium, size: 14))
                            .foregroundStyle(.labelSecondary)
                        Spacer()
                        Text("\(state.preferredDays.count) / \(state.daysPerWeek) SELECTED")
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .tracking(0.6)
                            .foregroundStyle(state.preferredDays.isEmpty ? .labelTertiary : .volt)
                    }

                    ChipFlowLayout(spacing: 8) {
                        ForEach(TrainingDay.allCases, id: \.self) { day in
                            SelectableChip(
                                label: day.rawValue,
                                isActive: state.preferredDays.contains(day)
                            ) { toggleDay(day) }
                        }
                    }
                }

				HStack {
					Text("SELECT GOALS")
						.font(.system(size: 10, weight: .semibold, design: .monospaced))
						.tracking(1.6)
						.foregroundStyle(.labelTertiary)
					Spacer()
					Text("\(state.goals.count) / \(maxGoals) SELECTED")
						.font(.system(size: 11, weight: .semibold, design: .monospaced))
						.tracking(0.6)
						.foregroundStyle(state.goals.isEmpty ? .labelTertiary : .volt)
				}

				ChipFlowLayout(spacing: 8) {
					ForEach(FitnessGoal.allCases, id: \.self) { goal in
						SelectableChip(
							label: goal.rawValue,
							isActive: state.goals.contains(goal)
						) { toggle(goal) }
					}
				}

				if !state.goals.isEmpty {
					VStack(alignment: .leading, spacing: 10) {
						Text("PRIORITY")
							.font(.system(size: 10, weight: .semibold, design: .monospaced))
							.tracking(1.6)
							.foregroundStyle(.labelTertiary)

						VStack(spacing: 0) {
							ForEach(state.goals.indices, id: \.self) { i in
								HStack(spacing: 12) {
									ZStack {
										RoundedRectangle(cornerRadius: 6)
											.fill(Color.voltDim)
											.frame(width: 24, height: 24)
										Text("\(i + 1)")
											.font(.system(size: 11, weight: .bold, design: .monospaced))
											.foregroundStyle(.volt)
									}

									Text(state.goals[i].rawValue)
										.font(.barlowCondensed(.bold, size: 15))
										.foregroundStyle(.labelPrimary)

									Spacer()

									Image(systemName: "ellipsis")
										.font(.system(size: 15))
										.foregroundStyle(.labelTertiary)
								}
								.padding(.horizontal, 16)
								.padding(.vertical, 12)

								if i < state.goals.count - 1 {
									Rectangle()
										.fill(Color.borderSubtle)
										.frame(height: 1)
										.padding(.horizontal, 16)
								}
							}
						}
						.background(Color.surfacePrimary)
						.clipShape(RoundedRectangle(cornerRadius: 12))
						.overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderDefault, lineWidth: 1))
					}
				}
            }
        }
    }
}

#Preview {
    RouterView {
        GoalsView(state: .constant(ProfileGoalsState()), onNext: {}, onBack: {})
    }
}
