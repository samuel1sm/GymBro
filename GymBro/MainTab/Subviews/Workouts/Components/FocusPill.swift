import SwiftUI

/// A small Volt-tinted pill labelling a session's focus, e.g. "Push" or "Full Body A".
struct FocusPill: View {
    var focus: String

    var body: some View {
        Text(focus)
            .font(.plusJakartaSans(.semiBold, size: 11))
            .kerning(0.1)
            .foregroundStyle(.volt)
            .frame(height: 19)
            .padding(.horizontal, 8)
            .background(.planTileBackground)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.planChipBorder, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 8) {
        FocusPill(focus: "Push")
        FocusPill(focus: "Pull")
        FocusPill(focus: "Legs")
    }
    .padding()
    .background(.appBackground)
}
