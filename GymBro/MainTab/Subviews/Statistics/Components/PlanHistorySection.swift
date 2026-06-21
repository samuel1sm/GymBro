import SwiftUI

/// "Plan History": a stack of past-plan rows plus a "View all plans" action.
struct PlanHistorySection: View {
    var plans: [PlanHistoryItem]
    var onSelect: (PlanHistoryItem) -> Void = { _ in }
    var onViewAll: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            StatsSectionHeader(title: "Plan History")

            VStack(spacing: 8) {
                ForEach(plans) { plan in
                    Button { onSelect(plan) } label: {
                        PlanHistoryRow(plan: plan)
                    }
                    .buttonStyle(.plain)
                }
            }

            Button(action: onViewAll) {
                HStack(spacing: 5) {
                    Text("View all plans")
                    Image(systemName: "arrow.right")
                        .font(.system(size: 13, weight: .medium))
                }
                .font(.plusJakartaSans(.medium, size: 13))
                .kerning(-0.1)
                .foregroundStyle(.labelSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
        }
        .padding(.horizontal, 20)
    }
}

/// A single plan row: name + meta on the left, a trailing chevron.
private struct PlanHistoryRow: View {
    var plan: PlanHistoryItem

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(plan.name)
                    .font(.plusJakartaSans(.medium, size: 13))
                    .kerning(-0.1)
                    .foregroundStyle(.labelPrimary)
                Text(plan.meta)
                    .font(.plusJakartaSans(.regular, size: 11))
                    .foregroundStyle(.labelTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.labelTertiary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.borderDefault, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    VStack {
        PlanHistorySection(plans: StatisticsState().plans)
        Spacer()
    }
    .background(.appBackground)
}
