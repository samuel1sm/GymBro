import SwiftUI

struct ProgressRingView: View {
    var progress: Double
    var glowing: Bool

    private let size: CGFloat = 220
    private let stroke: CGFloat = 10

    private var ringRadius: CGFloat { (size - stroke) / 2 }

    private var leadingAngle: Double {
        -Double.pi / 2 + 2 * Double.pi * progress
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(
                    colors: [Color.voltDim.opacity(0.8), Color.clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2 + 30
                ))
                .frame(width: size + 60, height: size + 60)
                .opacity(glowing ? 0.85 : 0.35)

            Circle()
                .stroke(Color.loaderTrack, lineWidth: stroke)
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.volt, style: StrokeStyle(lineWidth: stroke, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))

            VStack(spacing: 4) {
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("\(Int(progress * 100))")
                        .font(.barlowCondensed(.extraBold, size: 56))
                        .foregroundStyle(.labelPrimary)
                    Text("%")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.labelSecondary)
                }
                Text("GENERATING")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundStyle(.volt)
            }
        }
        .frame(width: size + 60, height: size + 60)
    }
}

// MARK: - Preview

#Preview {
    ProgressRingView(progress: 0.68, glowing: true)
        .padding(24)
        .background(.appBackground)
}

