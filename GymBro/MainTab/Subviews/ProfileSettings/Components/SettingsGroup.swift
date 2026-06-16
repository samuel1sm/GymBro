import SwiftUI

/// Grouped iOS-style list section — mono uppercase header + card of rows.
struct SettingsGroup<Content: View>: View {
    let title: LocalizedStringKey
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(1.6)
                .textCase(.uppercase)
                .foregroundStyle(.labelTertiary)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content
            }
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderSubtle, lineWidth: 1))
        }
        .padding(.horizontal, 20)
        .padding(.top, 32)
    }
}

// MARK: - Preview

#Preview {
    SettingsGroup(title: "Schedule") {
        SettingsRow(label: "Days per week", value: "4", isFirst: true)
        SettingsRow(label: "Session duration", value: "60 min")
        SettingsRow(label: "Preferred split", value: "Push / Pull / Legs")
    }
    .background(.appBackground)
}
