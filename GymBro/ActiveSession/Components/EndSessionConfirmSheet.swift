import SwiftUI

/// Confirmation sheet shown when the user backs out while sets are logged.
struct EndSessionConfirmSheet: View {
    var onResume: () -> Void
    var onEnd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Capsule()
                .fill(Color.borderSubtle)
                .frame(width: 36, height: 3)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 18)

            Text("End this session?")
                .font(.barlowCondensed(.bold, size: 22))
                .foregroundStyle(.labelPrimary)

            Text("You've logged sets. Ending now saves your progress as an incomplete workout.")
                .font(.plusJakartaSans(.regular, size: 14))
                .foregroundStyle(.labelSecondary)
                .padding(.top, 6)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 10) {
                Button(action: onResume) {
                    Text("Resume")
                        .font(.plusJakartaSans(.semiBold, size: 16))
                        .foregroundStyle(Color.labelOnAccent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.volt)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)

                Button(action: onEnd) {
                    Text("End session")
                        .font(.plusJakartaSans(.semiBold, size: 16))
                        .foregroundStyle(.labelSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.borderDefault, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 20)

            Color.clear.frame(height: 28)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfacePrimary)
        .clipShape(RoundedSheetShape(cornerRadius: 24))
        .overlay(
            RoundedSheetShape(cornerRadius: 24)
                .stroke(Color.borderDefault, lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    EndSessionConfirmSheet(onResume: {}, onEnd: {})
        .frame(maxHeight: .infinity, alignment: .bottom)
        .background(.appBackground)
}
