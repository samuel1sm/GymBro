import SwiftUI

enum OnboardingStates: Int {

	case firstView = 0
	case secondView = 1
	case thirdView = 2
}

struct OnboardingView: View {
	@Environment(\.coordinator) var coordinator
	@State private var selectedTab = 0
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

				ThirdOnboardingView(selectedTab: $selectedTab)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.horizontal, 16)
					.tag(OnboardingStates.thirdView.rawValue)
				}
				.tabViewStyle(.page)

				Spacer()

				VStack(spacing: 10) {
					GBButton(
						label: isLastTab ? "Get Started" : "Next",
						variant: .primary,
						size: .lg,
						iconRight: isLastTab ? nil : "chevron.right",
						isFullWidth: true
					) {
						if isLastTab {
							coordinator.push(.accountInformation)
						} else {
							selectedTab += 1
						}
					}

					if isLastTab {
						Button("I already have an account") {
							coordinator.push(.accountInformation)
						}
						.font(.system(size: 15, weight: .medium))
						.foregroundStyle(.labelSecondary)
						.frame(height: 48)
					}
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
