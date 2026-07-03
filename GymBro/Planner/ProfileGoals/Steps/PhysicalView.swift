import SwiftUI

struct PhysicalView: View {
    @Binding var state: ProfileGoalsState
    let onNext: () -> Void
    let onBack: () -> Void

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

    private var birthDateRange: ClosedRange<Date> {
        let earliest = Calendar.current.date(byAdding: .year, value: -100, to: .now) ?? .distantPast
        let latest = Calendar.current.date(byAdding: .year, value: -13, to: .now) ?? .now
        return earliest...latest
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
            step: .physical,
            title: "Your physical profile",
            subtitle: "We use this to dial in volume, load, and recovery.",
            onNext: onNext,
            onBack: onBack
        ) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date of birth")
                        .font(.plusJakartaSans(.medium, size: 14))
                        .foregroundStyle(.labelSecondary)

					Text(state.birthDate, format: .dateTime.day().month().year())
						.font(.system(size: 20, weight: .bold))
						.foregroundStyle(.labelPrimary)
						.padding(.horizontal, 12)
						.padding(.vertical, 8)
						.cornerRadius(8)
						.overlay {
							DatePicker("", selection: $state.birthDate, displayedComponents: .date)
								.labelsHidden()
								.blendMode(.destinationOver)
						}
						.padding(.horizontal, 16)
						.frame(height: 52)
						.background(Color.surfaceSecondary)
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.borderDefault, lineWidth: 1))
				}

                VStack(alignment: .leading, spacing: 8) {
                    Text("Biological sex")
                        .font(.plusJakartaSans(.medium, size: 14))
                        .foregroundStyle(.labelSecondary)

                    SegmentedPicker(options: ["Male", "Female", "not to say"], selectedIndex: sexIndex)
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
        PhysicalView(state: .constant(ProfileGoalsState()), onNext: {}, onBack: {})
    }
}
