import SwiftUI

private let maxGoals = 3

struct GoalsView: View {
    @Binding var state: ProfileGoalsState
    let onNext: () -> Void
    let onBack: () -> Void

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
            title: "What are you training for?",
            subtitle: "Pick up to three. We'll prioritise in that order.",
            ctaDisabled: state.goals.isEmpty,
            onNext: onNext,
            onBack: onBack
        ) {
            VStack(alignment: .leading, spacing: 20) {
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
