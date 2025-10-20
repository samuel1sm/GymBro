import SwiftUI

struct WorkoutExpirienceCustomisation: View {

	@State private var viewModel = WorkoutExpirienceViewModel()
	@State private var sheetHeight: CGFloat = 100

	var body: some View {
		VStack(alignment: .leading) {
			HStack(spacing: 16) {
				Image(systemName: "dumbbell.fill").frame(width: 16, height: 16)
				Text("Welcome to GymBro !")
				Spacer()
			}.padding(.leading, 4)
				.padding(.bottom, 4)

			Text("Let's personalize your experience")
				.font(.default)
				.foregroundStyle(.secondary)
				.padding(.bottom, 8)

			LoadingBarView(stage: viewModel.stage, hasStepCounter: true)
				.padding(.bottom, 16)

			StageView()
				.padding(.bottom, 24)

			HStack {
				Button {
					withAnimation(nil) {
						viewModel.backStage()
					}
				} label: {
					Text("Back")
				}
				.buttonStyle(.borderedStyle)
				.disabled(viewModel.stage == .personalInformations)

				Spacer()

				Button {
					withAnimation(nil) {
						if viewModel.stage == .healthIntegration {
							viewModel.createPlan()
						} else {
							viewModel.nextStage()
						}
					}
				} label: {
					Text(viewModel.stage == .healthIntegration ? "Generate My Plan" : "Next")
				}
				.buttonStyle(.filledBorderedStyle)
			}
		}
		.padding(16)
		.overlay(
			RoundedRectangle(cornerRadius: 8)
				.stroke(.gray, lineWidth: 1)
		)
		.padding(16)
		.sheet(
			isPresented: .constant(viewModel.selectedOption != nil),
			onDismiss: {
				viewModel.selectedOption = nil
				sheetHeight = 100
			}) {
				let cases: [any OptionsProtocol] = viewModel.selectedOption?.optionType.allCases as? [any OptionsProtocol] ?? []
				VStack(spacing: 16) {
					Text(viewModel.selectedOption?.title ?? "").font(.title2)
					Spacer()
					ForEach(Array(cases.enumerated()), id: \.offset) { _, option in
						Button {
							viewModel.saveSelectedOption(option)
							viewModel.selectedOption = nil
						} label: {
							Text(option.title.capitalized)
						}
					}
				}
				.padding(16)
				.background(
					GeometryReader { geo in
						Color.clear
							.onAppear { sheetHeight = geo.size.height }
							.onChange(of: geo.size.height) { _, newHeight in
								sheetHeight = newHeight
							}
					}
				)
				.presentationDetents([.height(sheetHeight)])
			}
	}

	@ViewBuilder
	private func StageView() -> some View {
		switch viewModel.stage {
		case .personalInformations:
			PersonalInformationView(
				model: $viewModel.data.personal,
				onTapGender: {
					viewModel.selectedOption = .gender
				}
			)
		case .trainingPreferences:
			TrainingPreferenceView(
				model: $viewModel.data.training
			) { option in
				viewModel.selectedOption = option
			}
		case .extraInformations:
			ExtraInformationsView(
				selectableOptions: $viewModel.data.muscles,
				equipamentOptions: $viewModel.data.equipment
			)
		case .injuriesAndRestrictions:
			InjuriesAndRestrictionsViews(injuryDescription: $viewModel.data.injuryDescription)
		case .healthIntegration:
			HealthIntegrationView(
				isAppleHealthCareEnable: $viewModel.data.integrations.appleHealth,
				isGoogleFitEnable: $viewModel.data.integrations.googleFit
			)
		}
	}
}


#Preview {
	WorkoutExpirienceCustomisation()
}
