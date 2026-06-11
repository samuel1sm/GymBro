import SwiftUI

/// Single list row — label, optional right-aligned value, optional trailing
/// control (switch, toggle) and optional disclosure chevron.
struct SettingsRow<Control: View>: View {
    var label: LocalizedStringKey
    var value: String? = nil
    var valueColor: Color = .labelSecondary
    var showsChevron: Bool = false
    var isFirst: Bool = false
    @ViewBuilder var control: Control

    init(
        label: LocalizedStringKey,
        value: String? = nil,
        valueColor: Color = .labelSecondary,
        showsChevron: Bool = false,
        isFirst: Bool = false,
        @ViewBuilder control: () -> Control = { EmptyView() }
    ) {
        self.label = label
        self.value = value
        self.valueColor = valueColor
        self.showsChevron = showsChevron
        self.isFirst = isFirst
        self.control = control()
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.plusJakartaSans(.medium, size: 16))
                .foregroundStyle(.labelPrimary)
                .fixedSize()

            Text(value ?? "")
                .font(.plusJakartaSans(.regular, size: 15))
                .foregroundStyle(valueColor)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .trailing)

            control

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.labelTertiary)
            }
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 54)
        .overlay(alignment: .top) {
            if !isFirst {
                GBDivider()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var on = true
    VStack(spacing: 0) {
        SettingsRow(label: "Goals", value: "Muscle Gain, Fat Loss", showsChevron: true, isFirst: true)
        SettingsRow(label: "Days per week", value: "4")
        SettingsRow(label: "Notifications") {
            GBSwitch(isOn: $on)
        }
    }
    .background(Color.surfacePrimary)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderSubtle, lineWidth: 1))
    .padding(20)
    .background(.appBackground)
}
