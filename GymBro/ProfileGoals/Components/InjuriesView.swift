import SwiftUI

struct InjuriesView: View {
    @Binding var step: Int
    @Binding var state: ProfileGoalsState

    private func toggleInjury(_ area: InjuryArea) {
        if area == .none {
            state.injuries = [.none]
        } else {
            state.injuries.remove(.none)
            if state.injuries.contains(area) {
                state.injuries.remove(area)
            } else {
                state.injuries.insert(area)
            }
        }
    }

    var body: some View {
        ProfileFrame(
            step: 5,
            title: "Injuries or limitations",
            subtitle: "Safety constraint — we'll filter contraindicated movements.",
            ctaLabel: "Generate Plan",
            onNext: { step += 1 },
            onBack: { step -= 1 }
        ) {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.plusJakartaSans(.medium, size: 14))
                        .foregroundStyle(.labelSecondary)

                    ZStack(alignment: .topLeading) {
                        if state.injuryNotes.isEmpty {
                            Text("Describe anything relevant — old injuries, tight areas, medical flags…")
                                .font(.system(size: 15))
                                .foregroundStyle(.labelMuted)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                        }
                        TextEditor(text: $state.injuryNotes)
                            .scrollContentBackground(.hidden)
                            .font(.system(size: 15))
                            .foregroundStyle(.labelPrimary)
                            .frame(minHeight: 104)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                    }
                    .background(Color.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.borderDefault, lineWidth: 1))
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("QUICK SELECT")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(1.6)
                        .foregroundStyle(.labelTertiary)

                    ChipFlowLayout(spacing: 8) {
                        ForEach(InjuryArea.allCases, id: \.self) { area in
                            SelectableChip(
                                label: area.rawValue,
                                isActive: state.injuries.contains(area)
                            ) { toggleInjury(area) }
                        }
                    }
                }

                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.voltDim)
                            .frame(width: 32, height: 32)
                        Image(systemName: "heart.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.volt)
                    }

                    Text("This is used as a **safety constraint** in your plan generation. We'll avoid loaded movements that aggravate listed areas.")
                        .font(.system(size: 12))
                        .foregroundStyle(.labelSecondary)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color.surfacePrimary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderDefault, lineWidth: 1))
            }
        }
    }
}

#Preview {
    RouterView {
        InjuriesView(step: .constant(5), state: .constant(ProfileGoalsState()))
    }
}
