import SwiftUI

/// Pinned footer with the Save Plan / Regenerate actions, separated from the
/// list by a hairline top border.
struct PlannerReviewBottomActions: View {
    let onSave: () -> Void
    let onRegenerate: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            GBButton(
                label: "Save Plan",
                variant: .primary,
                size: .lg,
                isFullWidth: true
            ) {
                onSave()
            }

            GBButton(
                label: "Regenerate",
                variant: .secondary,
                size: .lg,
                icon: "bolt.fill",
                isFullWidth: true
            ) {
                onRegenerate()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 14)
        .background(
            Color.appBackground
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Color.borderDefault)
                        .frame(height: 1)
                }
        )
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        PlannerReviewBottomActions(onSave: {}, onRegenerate: {})
    }
    .background(.appBackground)
}
