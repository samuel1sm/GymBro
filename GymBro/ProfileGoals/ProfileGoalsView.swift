import SwiftUI

struct ProfileGoalsView: View {
    @State private var step = 1
    @State private var state = ProfileGoalsState()

    var body: some View {
        Group {
            switch step {
            case 1: PhysicalView(step: $step, state: $state)
            case 2: FitnessLevelView(step: $step, state: $state)
            case 3: GoalsView(step: $step, state: $state)
            case 4: EquipmentView(step: $step, state: $state)
            default: InjuriesView(step: $step, state: $state)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: step)
    }
}

#Preview {
    RouterView {
        ProfileGoalsView()
    }
}
