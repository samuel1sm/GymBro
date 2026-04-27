import SwiftUI

enum OnboardingStates: Int {

	case firstView = 0
	case secondView = 1
	case thirdView = 2
}

struct OnboardingView: View {
	@Environment(\.coordinator) var coordinator
	@State private var selectedTab = 1
	var isLastTab: Bool {
		selectedTab == OnboardingStates.thirdView.rawValue
	}

	var body: some View {
		GeometryReader { geo in
			VStack {
				TabView(selection: $selectedTab) {
					FirstOnboardingView()
						.tag(OnboardingStates.firstView.rawValue)

					SecondOnboardingView(selectedTab: $selectedTab)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.horizontal, 16)
					.tag(OnboardingStates.secondView.rawValue)
				}
				.tabViewStyle(.page)

				Spacer()

				GBButton(
					label: "Next",
					variant: .primary,
					size: .lg,
					iconRight: "chevron.right",
					isFullWidth: true
				) {
					selectedTab += 1
				}
				.padding(.horizontal, 16)
				.padding(.bottom, 16)
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
