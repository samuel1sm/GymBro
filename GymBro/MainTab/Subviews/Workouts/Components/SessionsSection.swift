import SwiftUI

/// "SESSIONS" label plus the active plan's session cards.
struct SessionsSection: View {
    let sessions: [WorkoutsSession]
    let onSelect: (WorkoutsSession) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SESSIONS")
                .font(.plusJakartaSans(.semiBold, size: 13))
                .kerning(1)
                .foregroundStyle(.labelSecondary)

            VStack(spacing: 10) {
                ForEach(sessions) { session in
                    SessionCard(session: session) {
                        onSelect(session)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview

#Preview {
    SessionsSection(
        sessions: [
            WorkoutsSession(number: 1, name: "Training 1", focus: "Push", exercises: 6, minutes: 60, status: .done),
            WorkoutsSession(number: 2, name: "Training 2", focus: "Pull", exercises: 6, minutes: 65, status: .today),
            WorkoutsSession(number: 3, name: "Training 3", focus: "Legs", exercises: 7, minutes: 70, status: .upcoming),
        ],
        onSelect: { _ in }
    )
    .padding(.vertical, 20)
    .background(.appBackground)
}
