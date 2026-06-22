import SwiftUI

struct PlannerExerciseCard: View {
    let exercise: PlannerExercise
    var onSwap: () -> Void
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                Text(exercise.name)
                    .font(.plusJakartaSans(.medium, size: 17))
                    .foregroundStyle(.labelPrimary)
                    .lineLimit(1)

                Text(exercise.muscles)
                    .font(.plusJakartaSans(.regular, size: 14))
                    .foregroundStyle(.labelSecondary)
                    .padding(.top, 3)

                HStack(spacing: 6) {
                    PlannerSpecChip {
                        Text("\(exercise.sets) × \(exercise.reps)")
                    }
                    PlannerSpecChip {
                        Image(systemName: "timer")
                            .font(.system(size: 11, weight: .medium))
                        Text("\(exercise.restSeconds)s rest")
                    }
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {
                iconButton(
                    "arrow.2.squarepath",
                    tint: .labelTertiary,
                    background: .surfaceSecondary,
                    border: .borderDefault,
                    action: onSwap
                )

                iconButton(
                    "xmark",
                    tint: .danger,
                    background: Color.danger.opacity(0.12),
                    border: Color.danger.opacity(0.28),
                    action: onDelete
                )
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderSubtle, lineWidth: 1))
    }

    private func iconButton(
        _ systemName: String,
        tint: Color,
        background: Color,
        border: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 40, height: 40)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}
