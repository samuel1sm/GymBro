import SwiftUI

struct WelcomePageView: View {
    var body: some View {
		VStack(spacing: 24) {
			Text("GYMBRO").font(.barlowCondensed(.extraBold, size: 72)).foregroundStyle(.volt)
			Text("Your AI-powered workout planner.\nBuilt for strength, designed for results.")
				.font(.navTitle())
				.foregroundStyle(.labelSecondary)
				.multilineTextAlignment(.center)

			Button {

			} label: {
				Text("Get Started")
			}.buttonStyle(.bigRounded)
        }
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding(.all, 48)
		.background(.appBackground)
	}
}

#Preview {
    WelcomePageView()
}
