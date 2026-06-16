import SwiftUI

enum OnboardingStates: Int {

	case firstView = 0
	case secondView = 1
	case thirdView = 2
}

struct OnboardingView: View {
	@Environment(\.coordinator) var coordinator
	@State private var viewModel = OnboardingViewModel()

	var body: some View {
		@Bindable var vm = viewModel

		GeometryReader { geo in
			VStack {
				TabView(selection: $vm.selectedTab) {
					FirstOnboardingView()
						.tag(OnboardingStates.firstView.rawValue)

					SecondOnboardingView(selectedTab: $vm.selectedTab)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.horizontal, 16)
						.tag(OnboardingStates.secondView.rawValue)

				ThirdOnboardingView(selectedTab: $vm.selectedTab)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.horizontal, 16)
					.tag(OnboardingStates.thirdView.rawValue)
				}
				.tabViewStyle(.page)

				Spacer()

				VStack(spacing: 10) {
					GBButton(
						label: viewModel.isLastTab ? "Get Started" : "Next",
						variant: .primary,
						size: .lg,
						iconRight: viewModel.isLastTab ? nil : "chevron.right",
						isFullWidth: true
					) {
						if viewModel.isLastTab {
							coordinator.push(.profileGoals)
						} else {
							var transaction = Transaction()
							transaction.disablesAnimations = true
							withTransaction(transaction) {
								viewModel.advance()
							}
						}
					}

					if viewModel.isLastTab {
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
