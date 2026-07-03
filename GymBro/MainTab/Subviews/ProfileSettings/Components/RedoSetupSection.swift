import SwiftUI

/// Danger-zone footer — the "Redo Setup" reset button and its caption.
struct RedoSetupSection: View {
    let onRedo: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: onRedo) {
                Text("Redo Setup")
                    .font(.plusJakartaSans(.semiBold, size: 15))
                    .foregroundStyle(.danger)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderDefault, lineWidth: 1))
            }
            .buttonStyle(.plain)

            Text("Resets your profile and preferences. Your workout history is kept.")
                .font(.plusJakartaSans(.regular, size: 12))
                .foregroundStyle(.labelTertiary)
                .lineSpacing(3)
                .padding(.horizontal, 4)
        }
        .padding(.horizontal, 20)
        .padding(.top, 32)
        .padding(.bottom, 28)
    }
}

// MARK: - Preview

#Preview {
    RedoSetupSection {}
        .background(.appBackground)
}
