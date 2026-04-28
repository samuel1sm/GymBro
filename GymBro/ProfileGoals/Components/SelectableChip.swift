import SwiftUI

struct SelectableChip: View {
    let label: String
    var isActive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isActive {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                }
                Text(label)
                    .font(.plusJakartaSans(.semiBold, size: 14))
            }
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
