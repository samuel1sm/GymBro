import SwiftUI

/// Weekly training-volume bar chart: headline figure + week-over-week trend, a
/// gridlined column chart, and week-start labels on the x-axis.
struct WeeklyVolumeCard: View {
    var points: [VolumePoint]
    var currentVolumeLabel: String
    var trendPercent: Int

    // Chart geometry — mirrors the design spec.
    private let maxKg: Int = 16000
    private let ticks: [Int] = [16000, 8000, 0]
    private let chartHeight: CGFloat = 148
    private let yAxisWidth: CGFloat = 20
    private let chartGap: CGFloat = 10
    private let barSpacing: CGFloat = 7

    private var monoCaption: Font { .system(size: 9.5, weight: .regular, design: .monospaced) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headline
                .padding(.bottom, 20)

            chart

            xAxis
                .padding(.top, 9)
        }
        .padding(EdgeInsets(top: 18, leading: 18, bottom: 16, trailing: 18))
        .background(.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderDefault, lineWidth: 1))
    }

    // MARK: - Headline

    private var headline: some View {
        HStack(alignment: .firstTextBaseline, spacing: 7) {
            Text(currentVolumeLabel)
                .font(.barlowCondensed(.bold, size: 26))
                .kerning(-0.7)
                .monospacedDigit()
                .foregroundStyle(.labelPrimary)

            Text("kg this week")
                .font(.plusJakartaSans(.regular, size: 13))
                .kerning(-0.1)
                .foregroundStyle(.labelSecondary)

            Spacer(minLength: 0)

            HStack(spacing: 3) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 12, weight: .bold))
                Text("\(trendPercent)%")
                    .font(.plusJakartaSans(.semiBold, size: 13))
                    .monospacedDigit()
            }
            .foregroundStyle(.volt)
        }
    }

    // MARK: - Chart

    private var chart: some View {
        HStack(alignment: .top, spacing: chartGap) {
            yAxis
            plot
        }
    }

    private var yAxis: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(Array(ticks.enumerated()), id: \.offset) { index, tick in
                Text(tick == 0 ? "0" : "\(tick / 1000)k")
                    .font(monoCaption)
                    .foregroundStyle(.labelTertiary)
                if index < ticks.count - 1 { Spacer(minLength: 0) }
            }
        }
        .frame(width: yAxisWidth, height: chartHeight, alignment: .trailing)
    }

    private var plot: some View {
        ZStack(alignment: .bottom) {
            gridlines
            bars
        }
        .frame(height: chartHeight)
    }

    private var gridlines: some View {
        VStack(spacing: 0) {
            ForEach(ticks.indices, id: \.self) { index in
                Rectangle()
                    .fill(Color.borderDefault)
                    .frame(height: 1)
                if index < ticks.count - 1 { Spacer(minLength: 0) }
            }
        }
        .frame(height: chartHeight)
    }

    private var bars: some View {
        HStack(alignment: .bottom, spacing: barSpacing) {
            ForEach(points) { point in
                UnevenRoundedRectangle(
                    topLeadingRadius: 4, bottomLeadingRadius: 2,
                    bottomTrailingRadius: 2, topTrailingRadius: 4
                )
                .fill(point.isCurrent ? Color.volt : Color.voltMedium)
                .frame(maxWidth: .infinity)
                .frame(height: barHeight(for: point))
            }
        }
        .frame(height: chartHeight, alignment: .bottom)
    }

    // MARK: - X axis

    private var xAxis: some View {
        HStack(spacing: barSpacing) {
            ForEach(points) { point in
                Text(point.label)
                    .font(monoCaption)
                    .fontWeight(point.isCurrent ? .semibold : .regular)
                    .foregroundStyle(point.isCurrent ? Color.volt : Color.labelTertiary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.leading, yAxisWidth + chartGap)
    }

    // MARK: - Helpers

    private func barHeight(for point: VolumePoint) -> CGFloat {
        CGFloat(point.kilograms) / CGFloat(maxKg) * chartHeight
    }
}

// MARK: - Preview

#Preview {
    let state = StatisticsState()
    return WeeklyVolumeCard(
        points: state.weeklyVolume,
        currentVolumeLabel: "14,100",
        trendPercent: state.volumeTrendPercent
    )
    .padding()
    .background(.appBackground)
}
