import SwiftUI

enum OnboardingStates {
	case firstBoard
	case secondBoard
	case thirdBoard
}

struct OnboardingView: View {
	@State private var state = OnboardingStates.firstBoard

    var body: some View {
		GeometryReader { geo in
			VStack {
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

					GBButton(label: "Skip", variant: .secondary, size: .md)
						.padding()
				}

				VStack(alignment: .leading) {
					Text("01 · INTRO")
						.font(.system(size: 11, weight: .regular, design: .monospaced))
						.bold()
						.tracking(2.4)
						.foregroundStyle(.volt)

					let aiLabel = Text("AI")
						.font(.system(size: 44))
						.foregroundStyle(.volt)
					Text("Your \(aiLabel)\nGym Coach.")
						.font(.system(size: 44))
						.foregroundStyle(.labelPrimary)
						.bold()
					Text("Generate a personalised weekly workout plan in seconds.")
						.font(.system(size: 17))
						.foregroundStyle(.labelSecondary)
				}
				Spacer()
				GBButton(
					label: "Continue",
					variant: .primary,
					size: .lg,
					iconRight: "chevron.right",
					isFullWidth: true
				)
				.padding(.all, 16)
				.frame(maxWidth: .infinity)
			}
			.background(.appBackground)
		}
	}
}

#Preview {
	OnboardingView()
}
