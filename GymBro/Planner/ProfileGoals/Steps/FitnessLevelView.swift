import SwiftUI

struct FitnessLevelView: View {
    @Binding var state: ProfileGoalsState
    let onNext: () -> Void
    let onBack: () -> Void

    var body: some View {
        ProfileFrame(
            step: .fitnessLevel,
            title: "Your fitness level",
            subtitle: "Honest is best — the plan calibrates from here.",
            onNext: onNext,
            onBack: onBack
        ) {
            VStack(spacing: 10) {
                ForEach(FitnessLevel.allCases, id: \.self) { level in
                    levelCard(level)
                }
            }
        }
    }

    @ViewBuilder
    private func levelCard(_ level: FitnessLevel) -> some View {
        let selected = state.fitnessLevel == level
        Button { state.fitnessLevel = level } label: {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(selected ? Color.volt : Color.clear)
                    .frame(width: 4)
                    .padding(.vertical, 10)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(level.title)
                            .font(.barlowCondensed(.bold, size: 17))
                            .foregroundStyle(.labelPrimary)

                        Spacer()

                        Text(level.meta)
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.labelSecondary)
                            .tracking(1)

                        ZStack {
                            Circle()
                                .fill(selected ? Color.volt : Color.clear)
                                .frame(width: 22, height: 22)
                            Circle()
                                .strokeBorder(selected ? Color.volt : Color.borderDefault, lineWidth: 1.5)
                                .frame(width: 22, height: 22)
                            if selected {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(Color.labelOnAccent)
                            }
                        }
                    }

                    Text(level.description)
                        .font(.plusJakartaSans(.medium, size: 13))
                        .foregroundStyle(.labelSecondary)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(18)
            }
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selected ? Color.labelPrimary : Color.borderDefault, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RouterView {
        FitnessLevelView(state: .constant(ProfileGoalsState()), onNext: {}, onBack: {})
    }
}
