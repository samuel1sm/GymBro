import SwiftUI

struct WelcomePageView: View {
    var body: some View {
		VStack(spacing: 24) {
			Text(verbatim: "GYMBRO")
				.font(.barlowCondensed(.extraBold, size: 72))
				.foregroundStyle(.volt)
			Text(.welcomePageText)
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
