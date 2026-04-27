import SwiftUI

struct OnboardingView: View {
	@Environment(\.coordinator) var coordinator
	var body: some View {
		GeometryReader { geo in
			VStack {
				FirstOnboardView()

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
	RouterView {
		OnboardingView()
	}
}
