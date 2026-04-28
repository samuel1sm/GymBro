import SwiftUI

struct PhysicalView: View {
    @Environment(\.coordinator) private var coordinator
    @Binding var step: Int
    @Binding var state: ProfileGoalsState

    private var sexIndex: Binding<Int> {
        Binding(
            get: { state.sex == .male ? 0 : 1 },
            set: { state.sex = $0 == 0 ? .male : .female }
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

    var body: some View {
        ProfileFrame(
            step: 1,
            title: "Your physical profile",
            subtitle: "We use this to dial in volume, load, and recovery.",
            onNext: { step += 1 },
            onBack: { coordinator.pop() }
        ) {
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 12) {
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

                        SegmentedPicker(options: ["Male", "Female"], selectedIndex: sexIndex)
                            .frame(height: 52)
                            .opacity(state.sex == nil ? 0.4 : 1)
                    }
                }

                numericField(
                    label: "Weight",
                    display: state.weightDisplay,
                    unit: state.weightUnit.label,
                    unitOptions: ["LBS", "KG"],
                    unitIndex: weightUnitIndex
                )

                numericField(
                    label: "Height",
                    display: state.heightDisplay,
                    unit: state.heightUnit.label,
                    unitOptions: ["IN", "CM"],
                    unitIndex: heightUnitIndex
                )

                Button {
                    state.sex = (state.sex == nil) ? .male : nil
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "person")
                            .font(.system(size: 14))
                        Text("Prefer not to say")
                            .font(.plusJakartaSans(.medium, size: 13))
                    }
                    .foregroundStyle(state.sex == nil ? Color.volt : Color.labelSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(
                                state.sex == nil ? Color.volt : Color.borderDefault,
                                style: StrokeStyle(lineWidth: 1, dash: [6])
                            )
                    )
                }
                .buttonStyle(.plain)

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
        display: String,
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
                Text(display)
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
