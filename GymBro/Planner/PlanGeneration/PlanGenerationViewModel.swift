import SwiftUI
import Observation

/// View model for the Plan Generation screen.
///
/// Owns the step checklist, the rotating status copy and the simulated
/// progress, along with the timing loops that drive them. The view simply
/// kicks off the loops; all the timing and animation lives here.
/// (MainActor-isolated via the target's `SWIFT_DEFAULT_ACTOR_ISOLATION`,
/// like every view model in this module.)
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
    var generatedPlan: AIPlan.WorkoutPlan?

    /// Set when the service fails — drives the retry alert.
    var generationFailed = false

    /// Bumped by `retry()`; the view keys its generation `.task` on this.
    private(set) var attempt = 0

    // MARK: - Dependencies

    private let planService: PlanCreationService

    init(planService: PlanCreationService = SimulatedPlanCreationService()) {
        self.planService = planService
    }

    // MARK: - Derived

    var activeStepIndex: Int {
        min(steps.count - 1, Int(progress * Double(steps.count)))
    }

    func stepState(for index: Int) -> GenStepRow.StepState {
        if index < activeStepIndex { return .done }
        if index == activeStepIndex { return .active }
        return .pending
    }

    // MARK: - Lifecycle

    /// Starts the looping glow animation on the progress ring.
    func startGlow() {
        withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
            glowing = true
        }
    }

    /// Calls the plan creation service while the progress animation runs, then
    /// holds the full ring for a beat. On failure sets `generationFailed`; the
    /// view checks `Task.isCancelled` before routing onward.
    func generatePlan(from request: AIPlan.PlanRequest) async {
        generatedPlan = nil
        generationFailed = false
        async let plan = planService.createPlan(from: request)
        await runProgressLoop()
        generatedPlan = try? await plan
        guard !Task.isCancelled else { return }
        guard generatedPlan != nil else {
            generationFailed = true
            return
        }
        try? await Task.sleep(for: .milliseconds(400))
    }

    /// Rewinds the progress UI and re-keys the view's generation task.
    func retry() {
        progress = 0
        generationFailed = false
        attempt += 1
    }

    /// Advances the simulated progress ring until it reaches 100% (or the task
    /// is cancelled).
    private func runProgressLoop() async {
        while !Task.isCancelled && progress < 1.0 {
            try? await Task.sleep(nanoseconds: 120_000_000)
            guard !Task.isCancelled else { break }
            withAnimation(.linear(duration: 0.12)) {
                tickProgress()
            }
        }
    }

    /// Cycles the rotating status copy until cancelled.
    func runRotatingTextLoop() async {
        while !Task.isCancelled {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            guard !Task.isCancelled else { break }
            withAnimation(.easeOut(duration: 0.42)) {
                advanceRotatingText()
            }
        }
    }

    // MARK: - Actions

    private func tickProgress() {
        progress = min(1.0, progress + 0.018)
    }

    private func advanceRotatingText() {
        rotatingIndex = (rotatingIndex + 1) % rotatingTexts.count
    }
}
