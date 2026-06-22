import SwiftUI

/// Dashed-border button to add an exercise to the session — Volt label, matching
/// the Edit Workout design (distinct from the planner's secondary-tinted variant).
struct AddExerciseButton: View {
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                Text("Add exercise")
                    .font(.plusJakartaSans(.semiBold, size: 15))
            }
            .foregroundStyle(.volt)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.borderSubtle, style: StrokeStyle(lineWidth: 1.5, dash: [6]))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddExerciseButton {}
        .padding(20)
        .background(.appBackground)
}
