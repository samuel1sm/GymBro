import SwiftUI

/// Title + supporting copy heading the auth screens.
struct AuthHeader: View {
    let title: String
    let subtitle: String
    var titleSize: CGFloat = 28
    var subtitleTracking: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.barlowCondensed(.bold, size: titleSize))
                .tracking(-0.6)
                .foregroundStyle(.labelPrimary)
            Text(subtitle)
                .font(.plusJakartaSans(.regular, size: 14))
                .tracking(subtitleTracking)
                .foregroundStyle(.labelSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 32) {
        AuthHeader(
            title: "Welcome back",
            subtitle: "Sign in to pick up where you left off."
        )
        AuthHeader(
            title: "Save your plan",
            subtitle: "Create a free account so your plan, progress, and records sync across sessions.",
            titleSize: 25,
            subtitleTracking: -0.1
        )
    }
    .padding(24)
    .background(.appBackground)
}
