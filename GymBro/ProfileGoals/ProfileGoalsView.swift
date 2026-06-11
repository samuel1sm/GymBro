import SwiftUI

struct ProfileGoalsView: View {
    @State private var viewModel = ProfileGoalsViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        Group {
            switch viewModel.step {
            case 1: PhysicalView(step: $vm.step, state: $vm.state)
            case 2: FitnessLevelView(step: $vm.step, state: $vm.state)
            case 3: GoalsView(step: $vm.step, state: $vm.state)
            case 4: EquipmentView(step: $vm.step, state: $vm.state)
            default: InjuriesView(step: $vm.step, state: $vm.state)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: viewModel.step)
    }
}

#Preview {
    RouterView {
        ProfileGoalsView()
    }
}
