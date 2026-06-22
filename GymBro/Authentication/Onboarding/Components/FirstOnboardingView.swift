import SwiftUI

struct FirstOnboardingView: View {
	@Environment(\.coordinator) var coordinator
	let skipButtonAction: () -> Void

	var body: some View {
		GeometryReader { geo in
			VStack(spacing: 16) {
				ZStack(alignment: .topTrailing) {
					Image(.imgOnboardOne)
						.resizable()
						.scaledToFill()
						.frame(width: geo.size.width, height: geo.size.height * 0.6)
						.clipShape(
							UnevenRoundedRectangle(
								topLeadingRadius: 0,
								bottomLeadingRadius: 32,
								bottomTrailingRadius: 32,
								topTrailingRadius: 0
							)
						)
					
					GBButton(
						label: "Skip",
						variant: .secondary,
						size: .md,
						action: skipButtonAction
					)
					.padding()
				}

				VStack(alignment: .leading, spacing: 0) {
					Text("01 · INTRO")
						.font(.system(size: 11, weight: .bold, design: .monospaced))
						.tracking(2.4)
						.foregroundStyle(.volt)
						.padding(.bottom, 14)

					let aiText = Text("AI").foregroundColor(.volt)
					Text("Your \(aiText)\nGym Coach.")
						.foregroundColor(.labelPrimary)
						.font(.barlowCondensed(.black, size: 44))
						.lineSpacing(2)

					Text("Generate a personalised weekly workout plan in seconds.")
						.font(.system(size: 17))
						.foregroundStyle(.labelSecondary)
						.lineSpacing(5)
						.padding(.top, 14)
					Spacer()
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.horizontal, 16)
			}
		}
		.background(.appBackground)
	}
}

#Preview {
	RouterView {
		FirstOnboardingView(skipButtonAction: {})
	}
}
