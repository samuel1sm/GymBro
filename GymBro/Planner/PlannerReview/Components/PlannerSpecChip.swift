import SwiftUI

/// Small pill chip used inside exercise cards to show sets×reps and rest seconds.
struct PlannerSpecChip<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        HStack(spacing: 5) {
            content()
        }
        .font(.plusJakartaSans(.semiBold, size: 13))
        .foregroundStyle(.labelSecondary)
        .frame(height: 26)
        .padding(.horizontal, 9)
        .background(Color.surfaceSecondary)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.borderDefault, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 8) {
        PlannerSpecChip {
            Text("4 × 8–10")
        }
        PlannerSpecChip {
            Image(systemName: "timer")
                .font(.system(size: 11, weight: .medium))
            Text("120s rest")
        }
    }
    .padding(24)
    .background(.appBackground)
}
