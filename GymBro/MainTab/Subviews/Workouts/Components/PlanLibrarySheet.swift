import SwiftUI

/// The saved-plans library: a list of plans (the active one highlighted) plus a
/// "New Plan" action.
struct PlanLibrarySheet: View {
    var plans: [WorkoutPlan]
    var activePlanID: WorkoutPlan.ID
    var onPick: (WorkoutPlan) -> Void = { _ in }
    var onNewPlan: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SheetGrabber()

            Text("Your Plans")
                .font(.barlowCondensed(.bold, size: 22))
                .kerning(-0.4)
                .foregroundStyle(.labelPrimary)
                .padding(.horizontal, 2)
                .padding(.bottom, 14)

            VStack(spacing: 9) {
                ForEach(plans) { plan in
                    PlanRow(plan: plan, isActive: plan.id == activePlanID) {
                        onPick(plan)
                    }
                }
            }

            Button(action: onNewPlan) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                    Text("New Plan")
                        .font(.plusJakartaSans(.semiBold, size: 15))
                        .kerning(-0.1)
                }
                .foregroundStyle(.labelSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.borderSubtle, style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                )
            }
            .buttonStyle(.plain)
            .padding(.top, 12)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}

/// A single plan row in the library — name + meta, with an "Active" marker or a
/// trailing chevron.
private struct PlanRow: View {
    var plan: WorkoutPlan
    var isActive: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(plan.name)
                        .font(.plusJakartaSans(.semiBold, size: 15))
                        .kerning(-0.2)
                        .foregroundStyle(.labelPrimary)
                    Text(plan.meta)
                        .font(.plusJakartaSans(.regular, size: 12))
                        .kerning(-0.1)
                        .foregroundStyle(.labelTertiary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if isActive {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                        Text("Active")
                            .font(.plusJakartaSans(.semiBold, size: 12))
                    }
                    .foregroundStyle(.volt)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.labelTertiary)
                }
            }
            .padding(.vertical, 13)
            .padding(.horizontal, 14)
            .background(isActive ? Color.surfaceSecondary : Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isActive ? Color.volt : Color.borderSubtle, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    let state = WorkoutsState()
    return VStack {
        Spacer()
        PlanLibrarySheet(plans: state.plans, activePlanID: state.activePlanID)
            .background(.surfacePrimary)
    }
    .background(.appBackground)
}
