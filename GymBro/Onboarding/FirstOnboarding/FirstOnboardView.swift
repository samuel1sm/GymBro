import SwiftUI

struct FirstOnboardView: View {
	@Environment(\.coordinator) var coordinator
	
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
					
					GBButton(label: "Skip", variant: .secondary, size: .md) {
						coordinator.push(.firstOnboarding)
					}
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
			}
		}			.background(.appBackground)
	}
}

#Preview {
	RouterView {
		FirstOnboardView()
	}
}
