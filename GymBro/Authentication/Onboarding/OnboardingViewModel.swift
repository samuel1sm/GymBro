import Foundation
import Observation

@Observable
final class OnboardingViewModel {

    // MARK: - State

    var selectedTab: Int = OnboardingStates.firstView.rawValue

    // MARK: - Derived

    var isLastTab: Bool {
        selectedTab == OnboardingStates.thirdView.rawValue
    }

    // MARK: - Actions

    func advance() {
        selectedTab = min(selectedTab + 1, OnboardingStates.thirdView.rawValue)
    }

	func skipToLastTab() {
		selectedTab = OnboardingStates.thirdView.rawValue
	}
}
