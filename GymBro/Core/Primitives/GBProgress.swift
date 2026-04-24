import SwiftUI

struct GBProgress: View {
    /// 0.0 – 1.0
    var value: Double
    var height: CGFloat = 6
    var color: Color = .volt

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.loaderTrack)
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: geo.size.width * max(0, min(1, value)))
            }
        }
        .frame(height: height)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        VStack(spacing: 8) {
            HStack {
                Text("Volume · this week")
                    .font(.bodySM())
                    .foregroundStyle(.labelSecondary)
                Spacer()
                Text("12,480 / 18,000 LB")
                    .font(.bodySM())
                    .foregroundStyle(.labelPrimary)
                    .fontWeight(.semibold)
            }
            GBProgress(value: 0.69)
        }
        VStack(spacing: 8) {
            HStack {
                Text("Set 3 of 4")
                    .font(.bodySM())
                    .foregroundStyle(.labelSecondary)
                Spacer()
                Text("75%")
                    .font(.bodySM())
                    .foregroundStyle(.labelPrimary)
                    .fontWeight(.semibold)
            }
            GBProgress(value: 0.75, height: 10)
        }
    }
    .padding()
    .background(.appBackground)
}
