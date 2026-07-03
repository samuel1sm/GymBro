import SwiftUI

/// Layer 1 scroll body — one row per exercise plus the bordered
/// "End session" footer button.
struct ActiveSessionExerciseList: View {
    let exercises: [ActiveSessionExercise]
    /// Logged-set count per exercise, parallel to `exercises`.
    let doneCounts: [Int]
    let onTapExercise: (Int) -> Void
    let onEndSession: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                    ActiveSessionExerciseRow(
                        exercise: exercise,
                        index: index,
                        doneCount: doneCounts[index],
                        onTap: { onTapExercise(index) }
                    )
                }

                Button(action: onEndSession) {
                    Text("End session")
                        .font(.plusJakartaSans(.semiBold, size: 13))
                        .foregroundStyle(.labelSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.borderDefault, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .padding(.top, 6)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
    }
}

// MARK: - Preview

#Preview {
    ActiveSessionExerciseList(
        exercises: ActiveSessionState.seed,
        doneCounts: [4, 2, 0, 0, 0, 0],
        onTapExercise: { _ in },
        onEndSession: {}
    )
    .background(.appBackground)
}
