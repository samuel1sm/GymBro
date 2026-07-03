import SwiftUI

struct ProfileGoalsView: View {
    @Environment(\.coordinator) private var coordinator
    @State private var viewModel = ProfileGoalsViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        Group {
            switch viewModel.step {
            case .physical:
                PhysicalView(state: $vm.state, onNext: viewModel.next, onBack: { coordinator.pop() })
            case .fitnessLevel:
                FitnessLevelView(state: $vm.state, onNext: viewModel.next, onBack: viewModel.back)
            case .goals:
                GoalsView(state: $vm.state, onNext: viewModel.next, onBack: viewModel.back)
            case .equipment:
                EquipmentView(state: $vm.state, onNext: viewModel.next, onBack: viewModel.back)
            case .injuries:
                InjuriesView(
                    state: $vm.state,
                    onNext: { coordinator.push(.planGeneration(viewModel.state.toPlanRequest())) },
                    onBack: viewModel.back
                )
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
