import SwiftUI

/// Compact action sheet shown when a session is tapped: a header summarising the
/// session, then Start / Edit actions.
struct SessionActionSheet: View {
    var session: WorkoutsSession
    var onStart: () -> Void = {}
    var onEdit: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            SheetGrabber()

            HStack(spacing: 13) {
                FocusTile(number: session.number, size: 46)

                VStack(alignment: .leading, spacing: 3) {
                    Text("\(session.name) — \(session.focus)")
                        .font(.barlowCondensed(.bold, size: 20))
                        .kerning(-0.3)
                        .foregroundStyle(.labelPrimary)
                    Text(session.metaLabel)
                        .font(.plusJakartaSans(.regular, size: 12))
                        .kerning(-0.1)
                        .foregroundStyle(.labelSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 16)

            GBDivider()
                .padding(.bottom, 16)

            VStack(spacing: 10) {
                GBButton(label: "Start Workout", variant: .primary, size: .lg,
                         icon: "play.fill", isFullWidth: true, action: onStart)

                Button(action: onEdit) {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil")
                            .font(.system(size: 18, weight: .medium))
                        Text("Edit Workout")
                            .font(.plusJakartaSans(.semiBold, size: 17))
                    }
                    .foregroundStyle(.labelPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderSubtle, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        SessionActionSheet(session: WorkoutsState().sessions[2])
            .background(.surfacePrimary)
    }
    .background(.appBackground)
}
