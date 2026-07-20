import SwiftUI

struct SelectableChip: View {
    let label: String
    var isActive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.plusJakartaSans(.semiBold, size: 14))
            .foregroundStyle(isActive ? Color.labelOnAccent : Color.labelSecondary)
            .frame(height: 40)
            .padding(.horizontal, 16)
            .background(isActive ? Color.volt : Color.chipSurface)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(isActive ? Color.volt : Color.borderDefault, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 8) {
        SelectableChip(label: "Build muscle", isActive: true, action: {})
        SelectableChip(label: "Lose fat", action: {})
        SelectableChip(label: "Endurance", action: {})
    }
    .padding(24)
    .background(.appBackground)
}
