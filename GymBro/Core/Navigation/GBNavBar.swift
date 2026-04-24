import SwiftUI

struct GBNavBar: View {
    var title: String? = nil
    var subtitle: String? = nil
    var leadingIcon: String? = nil
    var trailingIcons: [String] = []
    var isLargeTitle: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                if let leadingIcon {
                    GBIconButton(icon: leadingIcon)
                }
                Spacer()
                HStack(spacing: 8) {
                    ForEach(trailingIcons, id: \.self) { icon in
                        GBIconButton(icon: icon)
                    }
                }
            }
            .frame(height: 44)

            if isLargeTitle, let title {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.heroLG())
                        .foregroundStyle(.labelPrimary)
                    if let subtitle {
                        Text(subtitle)
                            .font(.bodySM())
                            .foregroundStyle(.labelSecondary)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.appBackground)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        GBNavBar(
            title: "Workouts",
            subtitle: "Wed · Pull Day",
            leadingIcon: "chevron.left",
            trailingIcons: ["magnifyingglass", "ellipsis"]
        )
        GBDivider()
        Spacer()
    }
    .background(.appBackground)
}
