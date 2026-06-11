import SwiftUI

struct CTAGraphicView: View {
	private let ringSize: CGFloat = 220
	private let strokeWidth: CGFloat = 14

	var body: some View {
		VStack(spacing: 20) {
			ZStack {
				Circle()
					.stroke(Color.loaderTrack, lineWidth: strokeWidth)
					.frame(width: ringSize, height: ringSize)

				Circle()
					.trim(from: 0, to: 0.85)
					.stroke(Color.volt, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
					.frame(width: ringSize, height: ringSize)
					.rotationEffect(.degrees(-90))

				VStack(spacing: 4) {
					HStack(alignment: .lastTextBaseline, spacing: 2) {
						Text("3")
							.font(.barlowCondensed(.black, size: 64))
							.foregroundStyle(.labelPrimary)
						Text("min")
							.font(.system(size: 22, weight: .semibold))
							.foregroundStyle(.labelSecondary)
					}
					Text("SETUP TIME")
						.font(.system(size: 10, weight: .bold, design: .monospaced))
						.tracking(2)
						.foregroundStyle(.volt)
				}
			}

			HStack(spacing: 8) {
				let items: [LocalizedStringKey] = ["Profile", "Goals", "First plan"]
				ForEach(items.enumerated(), id: \.offset) { _, step in
					HStack(spacing: 6) {
						Circle()
							.fill(Color.volt)
							.frame(width: 6, height: 6)
						Text(step)
							.font(.system(size: 13, weight: .semibold))
							.foregroundStyle(.labelSecondary)
					}
					.frame(height: 30)
					.padding(.horizontal, 12)
					.background(Color.surfacePrimary)
					.clipShape(Capsule())
					.overlay(Capsule().stroke(Color.borderDefault, lineWidth: 1))
				}
			}
		}
	}
}

#Preview {
	CTAGraphicView()
		.padding()
		.background(.appBackground)
}
