import Foundation
import Observation

@Observable
final class ProfileGoalsViewModel {
    var step: ProfileGoalsStep = .physical
    var state = ProfileGoalsState()

    init(prefill: AIPlan.PlanRequest? = nil) {
        if let prefill {
            state = ProfileGoalsState(request: prefill)
        }
    }

    func next() {
        if let next = step.next { step = next }
    }

    func back() {
        if let previous = step.previous { step = previous }
    }
}
