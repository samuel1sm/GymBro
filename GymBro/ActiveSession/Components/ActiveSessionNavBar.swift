import SwiftUI

/// Top nav for the active workout session — back pill, volt split/day pill, more pill.
struct ActiveSessionNavBar: View {
    var split: String
    var day: Int
    var onBack: () -> Void
    var onMore: () -> Void

    var body: some View {
        HStack {
            roundPill {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.labelPrimary)
            } action: { onBack() }

            Spacer()

            Text("\(split) · DAY \(day)")
                .font(.plusJakartaSans(.semiBold, size: 12))
                .tracking(0.3)
                .foregroundStyle(.labelOnAccent)
                .padding(.horizontal, 14)
                .frame(height: 28)
                .background(Color.volt)
                .clipShape(Capsule())

            Spacer()

            roundPill {
                Image(systemName: "ellipsis")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.labelPrimary)
            } action: { onMore() }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func roundPill<Content: View>(@ViewBuilder content: () -> Content, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            content()
                .frame(width: 38, height: 38)
                .background(Color.surfaceSecondary)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.borderDefault, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ActiveSessionNavBar(split: "PUSH", day: 1, onBack: {}, onMore: {})
        .padding(.vertical, 24)
        .background(.appBackground)
}
