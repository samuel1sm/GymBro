import SwiftUI

/// Pill toast that fades in from the bottom — used to confirm Save / Regenerate.
struct PlannerToast: View {
    let message: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.volt)
            Text(message)
                .font(.plusJakartaSans(.semiBold, size: 14))
                .foregroundStyle(.labelPrimary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(Color.surfaceSecondary)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.borderSubtle, lineWidth: 1))
        .shadow(color: .black.opacity(0.45), radius: 14, x: 0, y: 8)
        .transition(.opacity.combined(with: .offset(y: 8)))
    }
}
