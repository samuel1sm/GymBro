import SwiftUI

/// Horizontal scrollable tab strip — one tab per training slot.
/// Active tab shows a volt underline.
struct PlannerTabStrip: View {
    let slots: [PlannerTrainingSlot]
    @Binding var activeIndex: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(Array(slots.enumerated()), id: \.element.id) { index, slot in
                    tab(slot: slot, isActive: index == activeIndex) {
                        activeIndex = index
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.borderDefault)
                .frame(height: 1)
        }
    }

    @ViewBuilder
    private func tab(slot: PlannerTrainingSlot, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(slot.name)
                    .font(.plusJakartaSans(isActive ? .bold : .medium, size: 15))
                    .foregroundStyle(isActive ? Color.labelPrimary : Color.labelTertiary)
                    .lineLimit(1)

                Text(slot.date)
                    .font(.plusJakartaSans(.medium, size: 12))
                    .foregroundStyle(.labelTertiary)

                Rectangle()
                    .fill(isActive ? Color.volt : Color.clear)
                    .frame(height: 2.5)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .padding(.top, 6)
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
        }
        .buttonStyle(.plain)
    }
}
