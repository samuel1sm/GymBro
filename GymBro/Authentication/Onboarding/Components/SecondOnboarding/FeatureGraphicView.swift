import SwiftUI

struct FeatureGraphicView: View {
    var body: some View {
        VStack(spacing: 10) {
            InputChip(
                icon: "trophy.fill",
                label: "GOAL",
                value: "Build strength"
            )
            InputChip(
                icon: "dumbbell.fill",
                label: "EQUIPMENT",
                value: "Full gym access"
            )
            InputChip(
                icon: "calendar",
                label: "SCHEDULE",
                value: "Mon · Wed · Fri · Sat"
            )

            // Arrow connector
            Circle()
                .fill(Color.volt)
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "arrow.down")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.black)
                )
                .padding(.vertical, 4)

            // Plan card
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.12))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.black)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("YOUR PLAN")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .tracking(1.6)
                        .foregroundStyle(Color.black.opacity(0.6))

                    Text("4-day Upper / Lower split")
                        .font(.barlowCondensed(.bold, size: 17))
                        .foregroundStyle(Color.black)
                }

                Spacer()
            }
            .padding(16)
            .background(Color.volt)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

#Preview {
	FeatureGraphicView()
		.background(.appBackground)
}
