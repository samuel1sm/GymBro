import SwiftUI

/// Condensed screen title heading the main-tab pages ("My Workouts",
/// "Statistics"…).
struct ScreenTitleHeader: View {
    let title: String
    var size: CGFloat = 24

    var body: some View {
        Text(title)
            .font(.barlowCondensed(.bold, size: size))
            .kerning(-0.5)
            .foregroundStyle(.labelPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 10)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        ScreenTitleHeader(title: "My Workouts")
        ScreenTitleHeader(title: "Statistics", size: 22)
        Spacer()
    }
    .background(.appBackground)
}
