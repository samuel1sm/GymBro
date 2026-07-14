import SwiftUI

/// Confirmation sheet shown before removing an exercise from a training slot.
struct PlannerRemoveExerciseSheet: View {
    let exercise: PlannerExercise
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.danger.opacity(0.14))
                        .frame(width: 56, height: 56)
                    Image(systemName: "trash")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.danger)
                }

                Text("Remove exercise?")
                    .font(.barlowCondensed(.bold, size: 28))
                    .foregroundStyle(.labelPrimary)

                Text("\(exercise.name) will be removed from this session. You can add it back anytime.")
                    .font(.plusJakartaSans(.medium, size: 15))
                    .foregroundStyle(.labelSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 10) {
                GBButton(
                    label: "Remove Exercise",
                    variant: .destruct,
                    size: .lg,
                    icon: "trash",
                    isFullWidth: true,
                    action: onConfirm
                )

                GBButton(
                    label: "Cancel",
                    variant: .secondary,
                    size: .lg,
                    isFullWidth: true,
                    action: onCancel
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
        .padding(.top, 28)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .presentationBackground(Color.appBackground)
        .presentationDetents([.height(340)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
    }
}

#Preview {
    Color.appBackground
        .sheet(isPresented: .constant(true)) {
            PlannerRemoveExerciseSheet(
                exercise: PlannerExercise(source: AIPlan.WorkoutPlan.reviewSeed.sessions[0].exercises[0]),
                onConfirm: {},
                onCancel: {}
            )
        }
}
