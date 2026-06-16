import SwiftUI

/// Today's session hero card. Shows the planned workout with a Start CTA, or a
/// recovery message on rest days. A volt left accent bar marks an active day.
struct TodaySessionCard: View {
    var isRestDay: Bool
    var title: String
    var detail: String
    var onStart: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            // Volt left accent bar (3pt), dimmed on rest days.
            Rectangle()
                .fill(isRestDay ? Color.borderSubtle : Color.volt)
                .frame(width: 3)

            VStack(alignment: .leading, spacing: 0) {
                Text("TODAY")
                    .font(.plusJakartaSans(.semiBold, size: 11))
                    .kerning(1.6)
                    .foregroundStyle(.labelTertiary)

                if isRestDay {
                    restContent
                } else {
                    sessionContent
                }
            }
            .padding(.vertical, 18)
            .padding(.leading, 21)
            .padding(.trailing, 18)
        }
        .background(.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.borderDefault, lineWidth: 1))
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - Training day

    private var sessionContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.barlowCondensed(.bold, size: 21))
                .kerning(-0.4)
                .foregroundStyle(.labelPrimary)
                .padding(.top, 5)

            Text(detail)
                .font(.plusJakartaSans(.regular, size: 13))
                .foregroundStyle(.labelSecondary)
                .padding(.top, 7)

            Button(action: onStart) {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 15))
                    Text("Start Workout")
                        .font(.plusJakartaSans(.semiBold, size: 15))
                }
                .foregroundStyle(.labelOnAccent)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.volt)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .padding(.top, 16)
        }
    }

    // MARK: - Rest day

    private var restContent: some View {
        HStack(spacing: 14) {
            Image(systemName: "heart")
                .font(.system(size: 22))
                .foregroundStyle(.labelSecondary)
                .frame(width: 46, height: 46)
                .background(.chipSurface)
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color.borderDefault, lineWidth: 1))

            VStack(alignment: .leading, spacing: 3) {
                Text("Rest Day")
                    .font(.barlowCondensed(.bold, size: 21))
                    .kerning(-0.4)
                    .foregroundStyle(.labelPrimary)
                Text("Recover well — next session tomorrow")
                    .font(.plusJakartaSans(.regular, size: 13))
                    .foregroundStyle(.labelSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(.top, 8)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        TodaySessionCard(isRestDay: false, title: "Training 3 — Pull Day", detail: "6 exercises · 60 min", onStart: {})
        TodaySessionCard(isRestDay: true, title: "", detail: "", onStart: {})
    }
    .background(.appBackground)
}
