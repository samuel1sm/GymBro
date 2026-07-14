import SwiftUI

/// Sheet offered when the user taps Cancel with unsaved edits.
struct DiscardChangesSheet: View {
    var onDiscard: () -> Void
    var onKeepEditing: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("Discard changes?")
                    .font(.barlowCondensed(.bold, size: 28))
                    .foregroundStyle(.labelPrimary)

                Text("Your edits to this session haven’t been saved. Discarding will undo them.")
                    .font(.plusJakartaSans(.medium, size: 15))
                    .foregroundStyle(.labelSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 10) {
                GBButton(
                    label: "Discard Changes",
                    variant: .destruct,
                    size: .lg,
                    isFullWidth: true,
                    action: onDiscard
                )
                GBButton(
                    label: "Keep Editing",
                    variant: .secondary,
                    size: .lg,
                    isFullWidth: true,
                    action: onKeepEditing
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
        .padding(.top, 28)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .presentationBackground(Color.appBackground)
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
    }
}

#Preview {
    Color.appBackground
        .sheet(isPresented: .constant(true)) {
            DiscardChangesSheet(onDiscard: {}, onKeepEditing: {})
        }
}
