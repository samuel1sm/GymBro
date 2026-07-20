import SwiftUI

/// Dashed bordered button to append an exercise to the current slot.
struct AddExerciseCard: View {
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .semibold))
                Text("Add Exercise")
                    .font(.plusJakartaSans(.semiBold, size: 15))
            }
            .foregroundStyle(.labelSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        Color.borderSubtle,
                        style: StrokeStyle(lineWidth: 1.5, dash: [6])
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    AddExerciseCard(onTap: {})
        .padding(20)
        .background(.appBackground)
}
