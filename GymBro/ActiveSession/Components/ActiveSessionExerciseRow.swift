import SwiftUI

/// One exercise row in the session overview list.
/// Tappable while incomplete; dimmed and inert once all sets are logged.
/// Volt progress bar pinned to the bottom edge.
struct ActiveSessionExerciseRow: View {
    let exercise: ActiveSessionExercise
    let index: Int
    let doneCount: Int
    var onTap: () -> Void

    private var isComplete: Bool { doneCount >= exercise.sets }
    private var fraction: Double { min(1, Double(doneCount) / Double(exercise.sets)) }

    var body: some View {
        Button(action: { if !isComplete { onTap() } }) {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 10) {
                    Text("\(index + 1)")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.labelTertiary)
                        .frame(width: 14, alignment: .leading)
                        .padding(.top, 2)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(exercise.name)
                            .font(.plusJakartaSans(.semiBold, size: 15))
                            .foregroundStyle(.labelPrimary)
                            .lineLimit(1)

                        Text(exercise.subtitle)
                            .font(.plusJakartaSans(.regular, size: 12))
                            .foregroundStyle(.labelSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    statusLabel
                        .padding(.top, 1)
                }
                .padding(.horizontal, 14)
                .padding(.top, 13)
                .padding(.bottom, 12)

                progressBar
            }
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderDefault, lineWidth: 1))
            .opacity(isComplete ? 0.5 : 1)
        }
        .buttonStyle(.plain)
        .disabled(isComplete)
        .animation(.easeInOut(duration: 0.28), value: isComplete)
    }

    private var statusLabel: some View {
        HStack(spacing: 4) {
            if isComplete {
                Text("\(exercise.sets)/\(exercise.sets) sets")
                    .font(.plusJakartaSans(.semiBold, size: 12))
                    .foregroundStyle(Color.volt)
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.volt)
            } else if doneCount > 0 {
                Text("\(doneCount)/\(exercise.sets) sets")
                    .font(.plusJakartaSans(.medium, size: 12))
                    .foregroundStyle(.labelSecondary)
            } else {
                Text("\(exercise.sets) × \(exercise.repLo)–\(exercise.repHi)")
                    .font(.plusJakartaSans(.medium, size: 12))
                    .foregroundStyle(.labelSecondary)
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.borderDefault.opacity(0.6))
                Rectangle()
                    .fill(Color.volt)
                    .frame(width: geo.size.width * fraction)
                    .animation(.spring(response: 0.42, dampingFraction: 0.85), value: fraction)
            }
        }
        .frame(height: 3)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 10) {
        ActiveSessionExerciseRow(exercise: ActiveSessionState.seed[0], index: 0, doneCount: 4, onTap: {})
        ActiveSessionExerciseRow(exercise: ActiveSessionState.seed[1], index: 1, doneCount: 2, onTap: {})
        ActiveSessionExerciseRow(exercise: ActiveSessionState.seed[2], index: 2, doneCount: 0, onTap: {})
    }
    .padding(20)
    .background(.appBackground)
}
