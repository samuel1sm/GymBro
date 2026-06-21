import SwiftUI

/// The "Active Plan" selector row — shows the current plan and opens the
/// saved-plans library when tapped.
struct PlanSelectorRow: View {
    var planName: String
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("ACTIVE PLAN")
                        .font(.plusJakartaSans(.semiBold, size: 11))
                        .kerning(1)
                        .foregroundStyle(.labelTertiary)
                    Text(planName)
                        .font(.plusJakartaSans(.semiBold, size: 15))
                        .kerning(-0.2)
                        .foregroundStyle(.labelPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 4) {
                    Text("Switch")
                        .font(.plusJakartaSans(.medium, size: 13))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(.labelSecondary)
            }
            .padding(12)
            .background(.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderSubtle, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    PlanSelectorRow(planName: "5-Day PPL Split")
        .padding()
        .background(.appBackground)
}
