import SwiftUI

private let gbSurface3 = Color(red: 0.18, green: 0.18, blue: 0.18)

struct GBChip: View {
    var label: String
    var isActive: Bool = false
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
            }
            Text(label)
                .font(.plusJakartaSans(.semiBold, size: 13))
        }
        .foregroundStyle(isActive ? Color.labelOnAccent : Color.labelSecondary)
        .frame(height: 32)
        .padding(.horizontal, 12)
        .background(isActive ? Color.volt : gbSurface3)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(isActive ? Color.volt : Color.borderDefault, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 8) {
            GBChip(label: "All", isActive: true)
            GBChip(label: "Chest")
            GBChip(label: "Back")
            GBChip(label: "Legs")
            GBChip(label: "Shoulders")
            GBChip(label: "Arms")
            GBChip(label: "Filter", icon: "line.3.horizontal.decrease")
        }
        .padding()
    }
    .background(.appBackground)
}
