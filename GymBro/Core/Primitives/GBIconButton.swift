import SwiftUI

// MARK: - Standard (surface)

struct GBIconButton: View {
    var icon: String
    var size: CGFloat = 40

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size * 0.475, weight: .regular))
            .foregroundStyle(.labelPrimary)
            .frame(width: size, height: size)
            .background(.surfaceSecondary)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.borderDefault, lineWidth: 1))
    }
}

// MARK: - Volt accent (FAB-style)

struct GBIconButtonVolt: View {
    var icon: String
    var size: CGFloat = 48

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size * 0.5, weight: .semibold))
            .foregroundStyle(.labelOnAccent)
            .frame(width: size, height: size)
            .background(.volt)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 12) {
        GBIconButton(icon: "chevron.left")
        GBIconButton(icon: "gearshape")
        GBIconButton(icon: "bell")
        GBIconButton(icon: "ellipsis")
        GBIconButtonVolt(icon: "plus")
    }
    .padding()
    .background(.appBackground)
}
