import SwiftUI

/// Greeting header — date eyebrow, "Greeting, Name" title, and the streak pill.
struct HomeHeader: View {
    var dateLabel: String
    var greeting: String
    var name: String
    var streak: Int

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateLabel)
                    .font(.plusJakartaSans(.semiBold, size: 12))
                    .kerning(1.2)
                    .foregroundStyle(.labelTertiary)

                Text("\(greeting), \(name)")
                    .font(.barlowCondensed(.bold, size: 26))
                    .kerning(-0.6)
                    .foregroundStyle(.labelPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            Spacer(minLength: 0)

            streakPill
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    private var streakPill: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.system(size: 14))
                .foregroundStyle(.volt)
            Text("\(streak)")
                .font(.plusJakartaSans(.semiBold, size: 13))
                .monospacedDigit()
                .foregroundStyle(.volt)
        }
        .frame(height: 34)
        .padding(.horizontal, 13)
        .background(.surfacePrimary)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.borderDefault, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    VStack {
        HomeHeader(dateLabel: "FRIDAY, MAY 29", greeting: "Good evening", name: "Alex", streak: 12)
        Spacer()
    }
    .background(.appBackground)
}
