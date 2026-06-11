import SwiftUI
import Observation

/// View model for the Plan Generation screen.
///
/// Owns the step checklist, the rotating status copy and the simulated
/// progress. The view drives the timing loops and wraps the ticks in
/// animations; this object is the single source of truth they mutate.
@Observable
final class PlanGenerationViewModel {

    // MARK: - Content

    let steps: [LocalizedStringKey] = [
        "Profile loaded",
        "Equipment validated",
        "Generating weekly structure",
        "Assigning exercises",
        "Adding coaching notes"
    ]

    let rotatingTexts: [LocalizedStringKey] = [
        "Analysing your goals…",
        "Allocating muscle groups…",
        "Balancing volume and recovery…",
        "Almost ready…"
    ]

    // MARK: - State

    var progress: Double = 0
    var rotatingIndex: Int = 0
    var glowing: Bool = false

    // MARK: - Derived

    var activeStepIndex: Int {
        min(steps.count - 1, Int(progress * Double(steps.count)))
    }

    func stepState(for index: Int) -> GenStepRow.StepState {
        if index < activeStepIndex { return .done }
        if index == activeStepIndex { return .active }
        return .pending
    }

    // MARK: - Actions

    func tickProgress() {
        progress += 0.018
        if progress >= 1.0 { progress = 0 }
    }

    func advanceRotatingText() {
        rotatingIndex = (rotatingIndex + 1) % rotatingTexts.count
    }
}
