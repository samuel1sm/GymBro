import SwiftUI

/// Chip reminding the user their freshly generated plan is waiting to be
/// saved — clipboard badge, plan title, and the "create an account" nudge.
struct PendingPlanChip: View {
    let planTitle: String

    var body: some View {
        HStack(spacing: 12) {
            ClipboardCheckIcon(size: 20, color: .volt)
                .frame(width: 40, height: 40)
                .background(.planTileBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.volt, lineWidth: 1))

            VStack(alignment: .leading, spacing: 2) {
                Text(planTitle)
                    .font(.plusJakartaSans(.semiBold, size: 13))
                    .tracking(-0.1)
                    .foregroundStyle(.labelPrimary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text("Your plan is ready — create an account to keep it")
                    .font(.plusJakartaSans(.regular, size: 11))
                    .foregroundStyle(.labelSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.planChipBorder, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    PendingPlanChip(planTitle: "Push · Pull · Legs — 4 days")
        .padding(24)
        .background(.appBackground)
}
