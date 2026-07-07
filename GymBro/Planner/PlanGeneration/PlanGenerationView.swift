import SwiftUI

// MARK: - View

struct PlanGenerationView: View {
    @Environment(\.coordinator) private var coordinator
    @Environment(\.pendingPlanStore) private var pendingPlanStore
    @Environment(\.userStore) private var userStore
    @State private var viewModel = PlanGenerationViewModel()

    let request: AIPlan.PlanRequest
    var flow: PlanFlow = .onboarding

    var body: some View {
        @Bindable var vm = viewModel

        VStack(spacing: 0) {
            Text("PLAN GENERATION")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(2.4)
                .foregroundStyle(.volt)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)

            Spacer()

            VStack(spacing: 24) {
                ProgressRingView(progress: viewModel.progress, glowing: viewModel.glowing)

                VStack(spacing: 0) {
                    Text("Building Your Plan")
                        .font(.barlowCondensed(.extraBold, size: 32))
                        .foregroundStyle(.labelPrimary)
                        .multilineTextAlignment(.center)

                    ZStack {
                        Text(viewModel.rotatingTexts[viewModel.rotatingIndex])
                            .font(.plusJakartaSans(.medium, size: 15))
                            .foregroundStyle(.labelSecondary)
                            .multilineTextAlignment(.center)
                            .id(viewModel.rotatingIndex)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(y: 6)),
                                removal: .opacity
                            ))
                    }
                    .padding(.top, 10)

                    Text("USUALLY TAKES 10–20 SECONDS")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .tracking(1.4)
                        .foregroundStyle(.labelTertiary)
                        .padding(.top, 8)
                }
            }

            Spacer()

            VStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.steps.indices, id: \.self) { i in
                    GenStepRow(
                        label: viewModel.steps[i],
                        stepState: viewModel.stepState(for: i)
                    )
                }
            }
			.frame(width: 280, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderDefault, lineWidth: 1))
			Spacer()
        }
        .padding(.horizontal, 24)
        .background(.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { viewModel.startGlow() }
        .task(id: viewModel.attempt) {
            await viewModel.generatePlan(from: request)
            guard !Task.isCancelled, let plan = viewModel.generatedPlan else { return }
            switch flow {
            case .onboarding:
                pendingPlanStore.stash(request: request, plan: plan)
                coordinator.push(.signUp)
            case .profileEdit:
                // Persist the edited profile now; the plan itself is saved
                // after the user reviews it on the next screen.
                do {
                    try userStore.saveUser(request)
                    pendingPlanStore.stash(request: request, plan: plan)
                    coordinator.push(.plannerReview(.profileEdit))
                } catch {
                    viewModel.generationFailed = true
                }
            }
        }
        .task { await viewModel.runRotatingTextLoop() }
        .alert("Couldn't build your plan", isPresented: $vm.generationFailed) {
            Button("Try Again") { viewModel.retry() }
            Button("Go Back", role: .cancel) { coordinator.pop() }
        } message: {
            Text("Something went wrong while generating your plan. Check your connection and try again.")
        }
    }
}

// MARK: - Progress Ring

#Preview {
    RouterView {
        PlanGenerationView(request: ProfileGoalsState().toPlanRequest())
    }
}
