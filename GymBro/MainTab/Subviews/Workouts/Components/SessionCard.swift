import SwiftUI

/// A tappable card for one session in the active plan: focus tile, name + focus
/// pill, meta line, and a trailing status indicator.
struct SessionCard: View {
    var session: WorkoutSession
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 13) {
                FocusTile(number: session.number)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(session.name)
                            .font(.plusJakartaSans(.semiBold, size: 15))
                            .kerning(-0.2)
                            .foregroundStyle(.labelPrimary)
                        FocusPill(focus: session.focus)
                    }
                    Text(session.metaLabel)
                        .font(.plusJakartaSans(.regular, size: 12))
                        .kerning(-0.1)
                        .foregroundStyle(.labelSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                SessionStatusView(status: session.status)
            }
            .padding(14)
            .background(.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderSubtle, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

/// The trailing indicator on a session card — varies by status.
private struct SessionStatusView: View {
    var status: SessionStatus

    var body: some View {
        switch status {
        case .done:
            statusLabel(icon: "checkmark", text: "Done", iconSize: 12)
        case .today:
            statusLabel(icon: "play.fill", text: "Today", iconSize: 10)
        case .upcoming:
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.labelTertiary)
        }
    }

    private func statusLabel(icon: String, text: String, iconSize: CGFloat) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: iconSize, weight: .bold))
            Text(text)
                .font(.plusJakartaSans(.semiBold, size: 11))
                .kerning(0.2)
        }
        .foregroundStyle(.volt)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 10) {
        ForEach(WorkoutsState().sessions) { session in
            SessionCard(session: session)
        }
    }
    .padding()
    .background(.appBackground)
}
