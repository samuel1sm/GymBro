import SwiftUI

/// Placeholder shown for tabs that don't have a screen yet (Workouts, Statistics).
struct ComingSoonView: View {
    var title: String
    var icon: String

    var body: some View {
        VStack(spacing: 0) {
            GBNavBar(title: title)
            Spacer()
            VStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 40, weight: .regular))
                    .foregroundStyle(.labelTertiary)
                Text("Coming soon")
                    .font(.plusJakartaSans(.semiBold, size: 15))
                    .foregroundStyle(.labelSecondary)
            }
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}

// MARK: - Preview

#Preview {
    ComingSoonView(title: "Workouts", icon: "dumbbell")
}
