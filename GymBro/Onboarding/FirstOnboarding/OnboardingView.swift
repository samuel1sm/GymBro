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
					FirstOnboardView()
						.tag(OnboardingStates.firstView.rawValue)

					VStack {
						VStack(alignment: .leading) {
							Text("02 · How it works")
								.font(.system(size: 11, weight: .regular, design: .monospaced))
								.bold()
								.tracking(2.4)
								.foregroundStyle(.volt)

							let youLabel = Text("You.")
								.font(.system(size: 44))
								.foregroundStyle(.volt)
							Text("Built.\nAround \(youLabel)")
								.font(.system(size: 44))
								.foregroundStyle(.labelPrimary)
								.bold()
							Text("Tell us your goals, equipment, and schedule. We handle the rest.")
								.font(.system(size: 17))
								.foregroundStyle(.labelSecondary)
						}
					}
					.padding(.horizontal, 16)
					.frame(maxWidth: .infinity, alignment: .leading)


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
