import SwiftUI

/// A rounded-square tile showing a session's training number in condensed Volt
/// type, on a SurfaceSecondary fill.
struct FocusTile: View {
    var number: Int
    var size: CGFloat = 42

    var body: some View {
        Text("\(number)")
            .font(.barlowCondensed(.bold, size: size * 0.48))
            .kerning(0.2)
            .monospacedDigit()
            .foregroundStyle(.volt)
            .frame(width: size, height: size)
            .background(.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.borderDefault, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 12) {
        FocusTile(number: 3)
        FocusTile(number: 5, size: 46)
    }
    .padding()
    .background(.appBackground)
}
