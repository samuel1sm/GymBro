import Foundation
import Observation

/// View model for the Onboarding carousel.
///
/// Owns the selected tab and the paging logic. The view is a thin
/// projection of this object via `@Bindable`.
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
        selectedTab += 1
    }
}
