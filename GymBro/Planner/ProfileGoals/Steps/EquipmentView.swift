import SwiftUI

struct EquipmentView: View {
    @Binding var state: ProfileGoalsState
    let onNext: () -> Void
    let onBack: () -> Void

    private func toggle(_ option: EquipmentOption) {
        if state.equipment.contains(option) {
            state.equipment.remove(option)
        } else {
            state.equipment.insert(option)
        }
    }

    var body: some View {
        ProfileFrame(
            step: .equipment,
            title: "What gear do you have?",
            subtitle: "Select all that apply. 'Full gym' covers everything.",
            onNext: onNext,
            onBack: onBack
        ) {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("AVAILABLE EQUIPMENT")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(1.6)
                        .foregroundStyle(.labelTertiary)
                    Spacer()
                    Text("\(state.equipment.count) SELECTED")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundStyle(state.equipment.isEmpty ? .labelTertiary : .volt)
                }

                ChipFlowLayout(spacing: 8) {
                    ForEach(EquipmentOption.allCases.filter { $0 != .fullGym }, id: \.self) { option in
                        SelectableChip(
                            label: option.rawValue,
                            isActive: state.equipment.contains(option)
                        ) { toggle(option) }
                    }
                }

                let fullGymActive = state.equipment.contains(.fullGym)
                Button {
                    state.equipment = [.fullGym]
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.voltDim)
                                .frame(width: 40, height: 40)
                            Image(systemName: "dumbbell.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.volt)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("I have a full gym")
                                .font(.barlowCondensed(.bold, size: 15))
                                .foregroundStyle(.labelPrimary)
                            Text("Unlocks all exercise variations")
                                .font(.plusJakartaSans(.medium, size: 12))
                                .foregroundStyle(.labelSecondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.labelTertiary)
                    }
                    .padding(16)
                    .background(Color.surfacePrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(fullGymActive ? Color.volt : Color.borderDefault, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    RouterView {
        EquipmentView(state: .constant(ProfileGoalsState()), onNext: {}, onBack: {})
    }
}
