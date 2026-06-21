import SwiftUI

/// A small Volt-tinted pill labelling a session's focus (Push / Pull / Legs).
struct FocusPill: View {
    var focus: SessionFocus

    var body: some View {
        Text(focus.label)
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
        FocusPill(focus: .push)
        FocusPill(focus: .pull)
        FocusPill(focus: .legs)
    }
    .padding()
    .background(.appBackground)
}
