import SwiftUI

/// The pill-shaped drag handle at the top of the Workouts bottom sheets.
struct SheetGrabber: View {
    var body: some View {
        Capsule()
            .fill(Color.borderSubtle)
            .frame(width: 38, height: 4)
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
            .padding(.bottom, 14)
    }
}

// MARK: - Preview

#Preview {
    SheetGrabber()
        .background(.surfacePrimary)
}
