import SwiftUI

struct PhysicalView: View {
    @Environment(\.coordinator) private var coordinator
    @Binding var step: Int
    @Binding var state: ProfileGoalsState

    private var sexIndex: Binding<Int> {
        Binding(
            get: {
                switch state.sex {
                case .male: return 0
                case .female: return 1
                case .preferNotToSay: return 2
                }
            },
            set: {
                switch $0 {
                case 0: state.sex = .male
                case 1: state.sex = .female
                default: state.sex = .preferNotToSay
                }
            }
        )
    }

    private var weightUnitIndex: Binding<Int> {
        Binding(
            get: { state.weightUnit == .lbs ? 0 : 1 },
            set: { state.weightUnit = $0 == 0 ? .lbs : .kg }
        )
    }

    private var heightUnitIndex: Binding<Int> {
        Binding(
            get: { state.heightUnit == .inches ? 0 : 1 },
            set: { state.heightUnit = $0 == 0 ? .inches : .cm }
        )
    }

    private var weightValue: Binding<Int> {
        Binding(
            get: { state.weightUnit == .lbs ? state.weightLbs : state.weightKg },
            set: {
                if state.weightUnit == .lbs { state.weightLbs = $0 }
                else { state.weightKg = $0 }
            }
        )
    }

    private var heightValue: Binding<Int> {
        Binding(
            get: { state.heightUnit == .inches ? state.heightIn : state.heightCm },
            set: {
                if state.heightUnit == .inches { state.heightIn = $0 }
                else { state.heightCm = $0 }
            }
        )
    }

    var body: some View {
        ProfileFrame(
            step: 1,
            title: "Your physical profile",
            subtitle: "We use this to dial in volume, load, and recovery.",
            onNext: { step += 1 },
            onBack: { coordinator.pop() }
        ) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Age")
                        .font(.plusJakartaSans(.medium, size: 14))
                        .foregroundStyle(.labelSecondary)

                    HStack(spacing: 0) {
                        Button {
                            if state.age > 13 { state.age -= 1 }
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.labelSecondary)
                                .frame(width: 44, height: 52)
                        }
                        .buttonStyle(.plain)

                        Rectangle().fill(Color.borderDefault).frame(width: 1, height: 24)

                        Text("\(state.age)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.labelPrimary)
                            .frame(maxWidth: .infinity)

                        Rectangle().fill(Color.borderDefault).frame(width: 1, height: 24)

                        Button {
                            if state.age < 100 { state.age += 1 }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.volt)
                                .frame(width: 44, height: 52)
                        }
                        .buttonStyle(.plain)
                    }
                    .background(Color.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.borderDefault, lineWidth: 1))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Biological sex")
                        .font(.plusJakartaSans(.medium, size: 14))
                        .foregroundStyle(.labelSecondary)

                    SegmentedPicker(options: ["Male", "Female", "Prefer not to say"], selectedIndex: sexIndex)
                        .frame(height: 52)
                }

                numericField(
                    label: "Weight",
                    value: weightValue,
                    unit: state.weightUnit.label,
                    unitOptions: ["LBS", "KG"],
                    unitIndex: weightUnitIndex
                )

                numericField(
                    label: "Height",
                    value: heightValue,
                    unit: state.heightUnit.label,
                    unitOptions: ["IN", "CM"],
                    unitIndex: heightUnitIndex
                )

                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Color.volt)
                        .frame(width: 4, height: 4)
                        .padding(.top, 7)
                    Text("Values stay on-device until you generate your first plan.")
                        .font(.system(size: 12))
                        .foregroundStyle(.labelTertiary)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.surfacePrimary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.borderSubtle, lineWidth: 1))
            }
        }
    }

    @ViewBuilder
    private func numericField(
        label: String,
        value: Binding<Int>,
        unit: String,
        unitOptions: [String],
        unitIndex: Binding<Int>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.plusJakartaSans(.medium, size: 14))
                    .foregroundStyle(.labelSecondary)
                Spacer()
                SegmentedPicker(options: unitOptions, selectedIndex: unitIndex, compact: true)
                    .frame(width: 96)
            }

            HStack {
                TextField("", value: value, format: .number)
                    .keyboardType(.numberPad)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.labelPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(unit)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.labelSecondary)
            }
            .frame(height: 52)
            .padding(.horizontal, 16)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.borderDefault, lineWidth: 1))
        }
    }
}

#Preview {
    RouterView {
        PhysicalView(step: .constant(1), state: .constant(ProfileGoalsState()))
    }
}
