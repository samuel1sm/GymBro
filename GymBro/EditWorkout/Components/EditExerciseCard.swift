import SwiftUI

/// An exercise row in the editor.
///
/// Tapping the card body toggles an inline editor (sets stepper + reps/rest
/// fields). The trailing buttons swap or remove the exercise. Reordering is
/// handled by the enclosing `List`'s `onMove` (long-press drag).
struct EditExerciseCard: View {
    let exercise: EditExercise
    let isExpanded: Bool
    var repsText: Binding<String>
    var restText: Binding<String>
    var onTap: () -> Void
    var onSwap: () -> Void
    var onDelete: () -> Void
    var onStepSets: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
                .contentShape(Rectangle())
                .onTapGesture(perform: onTap)

            if isExpanded {
                editor
                    .transition(.opacity)
            }
        }
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderSubtle, lineWidth: 1))
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                Text(exercise.name)
                    .font(.plusJakartaSans(.semiBold, size: 15))
                    .foregroundStyle(.labelPrimary)
                    .lineLimit(1)

                Text(exercise.muscles)
                    .font(.plusJakartaSans(.regular, size: 11))
                    .foregroundStyle(.labelSecondary)
                    .padding(.top, 3)

                HStack(spacing: 6) {
                    EditSpecChip(text: "\(exercise.sets) × \(exercise.reps)")
                    EditSpecChip(text: "\(exercise.rest) rest")
                }
                .padding(.top, 9)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 8) {
                iconButton(
                    "arrow.2.squarepath",
                    tint: .labelTertiary,
                    background: .surfaceSecondary,
                    border: .borderSubtle,
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
        .padding(.vertical, 12)
    }

    // MARK: - Inline editor

    private var editor: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.borderDefault)
                .frame(height: 1)
                .padding(.bottom, 2)

            editRow(label: "Sets") {
                SetsStepper(value: exercise.sets, onStep: onStepSets)
            }
            editRow(label: "Reps") {
                MiniField(text: repsText)
            }
            editRow(label: "Rest") {
                MiniField(text: restText)
            }
        }
        .padding(.horizontal, 14)
        .padding(.bottom, 12)
    }

    private func editRow<Trailing: View>(label: String, @ViewBuilder trailing: () -> Trailing) -> some View {
        HStack {
            Text(label)
                .font(.plusJakartaSans(.medium, size: 13))
                .foregroundStyle(.labelSecondary)
            Spacer()
            trailing()
        }
        .frame(height: 38)
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

// MARK: - Sets stepper

/// `− value +` control. Steps clamp to a minimum of 1 in the view model.
private struct SetsStepper: View {
    let value: Int
    var onStep: (Int) -> Void

    var body: some View {
        HStack(spacing: 0) {
            button("minus") { onStep(-1) }

            Text("\(value)")
                .font(.plusJakartaSans(.semiBold, size: 15))
                .monospacedDigit()
                .foregroundStyle(.labelPrimary)
                .frame(minWidth: 30)

            button("plus") { onStep(1) }
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 9))
        .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color.borderSubtle, lineWidth: 1))
    }

    private func button(_ systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.volt)
                .frame(width: 34, height: 34)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Reps / Rest field

private struct MiniField: View {
    @Binding var text: String

    var body: some View {
        TextField("", text: $text)
            .font(.plusJakartaSans(.semiBold, size: 14))
            .foregroundStyle(.labelPrimary)
            .multilineTextAlignment(.center)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .frame(width: 84, height: 34)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 9))
            .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color.borderSubtle, lineWidth: 1))
    }
}

#Preview {
    VStack(spacing: 10) {
        EditExerciseCard(
            exercise: .init(name: "Barbell Bench Press", muscles: "Chest · Front Delts", sets: 4, reps: "6–8", rest: "120s"),
            isExpanded: false,
            repsText: .constant("6–8"),
            restText: .constant("120s"),
            onTap: {}, onSwap: {}, onDelete: {}, onStepSets: { _ in }
        )
        EditExerciseCard(
            exercise: .init(name: "Overhead Triceps Extension", muscles: "Triceps", sets: 3, reps: "10–12", rest: "60s"),
            isExpanded: true,
            repsText: .constant("10–12"),
            restText: .constant("60s"),
            onTap: {}, onSwap: {}, onDelete: {}, onStepSets: { _ in }
        )
    }
    .padding(20)
    .background(.appBackground)
}
