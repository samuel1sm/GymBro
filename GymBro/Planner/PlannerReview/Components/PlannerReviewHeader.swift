import SwiftUI

/// Review-plan header — back chevron, "REVIEW PLAN" kicker, and the
/// "Your Week" title with its instruction line.
struct PlannerReviewHeader: View {
    let onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.labelPrimary)
                        .padding(8)
                }
                .buttonStyle(.plain)

                Spacer()

                Text("REVIEW PLAN")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .tracking(1.6)
                    .foregroundStyle(.labelSecondary)

                Spacer()

                Color.clear.frame(width: 36, height: 36)
            }
            .frame(height: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text("Your Week")
                    .font(.barlowCondensed(.bold, size: 32))
                    .foregroundStyle(.labelPrimary)

                Text("Review each session, swap or reorder exercises, then save.")
                    .font(.plusJakartaSans(.medium, size: 14))
                    .foregroundStyle(.labelSecondary)
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, 20)
        .padding(.top, 2)
        .padding(.bottom, 14)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        PlannerReviewHeader {}
        Spacer()
    }
    .background(.appBackground)
}
