import Foundation
import Observation

@Observable
final class ProfileGoalsViewModel {
    var step: ProfileGoalsStep = .physical
    var state = ProfileGoalsState()

    func next() {
        if let next = step.next { step = next }
    }

    func back() {
        if let previous = step.previous { step = previous }
    }
}
