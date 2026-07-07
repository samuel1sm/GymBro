import SwiftUI

struct ProfileGoalsView: View {
    @Environment(\.coordinator) private var coordinator
    @State private var viewModel: ProfileGoalsViewModel

    private let flow: PlanFlow

    /// A non-nil `prefill` means the user is editing their saved profile, so
    /// the whole flow (including plan generation) runs in `.profileEdit` mode.
    init(prefill: AIPlan.PlanRequest? = nil) {
        _viewModel = State(initialValue: ProfileGoalsViewModel(prefill: prefill))
        flow = prefill == nil ? .onboarding : .profileEdit
    }

    var body: some View {
        @Bindable var vm = viewModel

        Group {
            switch viewModel.step {
            case .physical:
                PhysicalView(
                    state: $vm.state,
                    showsIdentityFields: flow == .onboarding,
                    onNext: viewModel.next,
                    onBack: { coordinator.pop() }
                )
            case .fitnessLevel:
                FitnessLevelView(state: $vm.state, onNext: viewModel.next, onBack: viewModel.back)
            case .goals:
                GoalsView(state: $vm.state, onNext: viewModel.next, onBack: viewModel.back)
            case .equipment:
                EquipmentView(state: $vm.state, onNext: viewModel.next, onBack: viewModel.back)
            case .injuries:
                InjuriesView(
                    state: $vm.state,
                    onNext: { coordinator.push(.planGeneration(viewModel.state.toPlanRequest(), flow)) },
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
