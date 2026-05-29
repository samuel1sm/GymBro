import SwiftUI

/// Header card for a training slot — volt left accent bar + focus + meta.
struct SessionHeaderCard: View {
    let slot: PlannerTrainingSlot

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.volt)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 0) {
                Text("\(slot.name) · \(slot.date)")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .tracking(1.6)
                    .foregroundStyle(.labelTertiary)
                    .textCase(.uppercase)

                Text(slot.focus)
                    .font(.barlowCondensed(.bold, size: 22))
                    .foregroundStyle(.labelPrimary)
                    .padding(.top, 6)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 14) {
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 13, weight: .medium))
                        Text("~\(slot.estimatedMinutes) min")
                            .font(.plusJakartaSans(.medium, size: 13))
                    }
                    .foregroundStyle(.labelSecondary)

                    Circle()
                        .fill(Color.labelTertiary)
                        .frame(width: 3, height: 3)

                    HStack(spacing: 6) {
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 12, weight: .medium))
                        Text("\(slot.exercises.count) exercises")
                            .font(.plusJakartaSans(.medium, size: 13))
                    }
                    .foregroundStyle(.labelSecondary)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderSubtle, lineWidth: 1))
    }
}
