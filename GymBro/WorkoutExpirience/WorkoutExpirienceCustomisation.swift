import SwiftUI

struct WorkoutExpirienceCustomisation: View {

	@State private var stage: CustomisationStages = .trainingPreferences
	@State private var isSheetPresented: Bool = false
	@State private var personalModel = PersonalInformationModel()
	@State private var trainingPreferencesModel = TrainingPreferencesModel()

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

			LoadingBarView(stage: stage, hasStepCounter: true)
				.padding(.bottom, 16)

			StageView()
			.padding(.bottom, 24)

			HStack {
				Button {
					stage = stage.getPreviousStage()
				} label: {
					Text("Back")
				}

				Spacer()

				Button {
					stage = stage.getNextStage()
				} label: {
					Text("Next")
				}
			}
		}
		.padding(16)
		.overlay(
			RoundedRectangle(cornerRadius: 8)
				.stroke(.gray, lineWidth: 1)
		)
		.padding(16)
		.sheet(isPresented: $isSheetPresented) {
			VStack(spacing: 16) {
				EmptyView().frame(height: 16)
				Text("Select your gender").font(.title2)
				Spacer()
				ForEach(SexOptions.allCases, id: \.self) { option in
					Button(option.rawValue.capitalized) {
						personalModel.gender = option
						isSheetPresented = false
					}
				}
				EmptyView().frame(height: 16)
			}
			.padding(16)
			.presentationDetents([.height(200)])
		}
	}

	@ViewBuilder
	private func StageView() -> some View {
		switch stage {
		case .personalInformations:
			PersonalInformationView(
				model: $personalModel,
				onTapGender: { isSheetPresented = true }
			)
		case .trainingPreferences:
			VStack(spacing: 16) {
				HStack(spacing: 16) {
					Image(systemName: "target").frame(width: 16, height: 16)
					Text("Training Preferences")
					Spacer()
				}

				DefaultSelectableField<TrainingDaysPerWeekOptions>(
					title: "Training days per week",
					option: $trainingPreferencesModel.trainingOption,
					placeholder: "Ex.: 2 Days",
					selectableAction: { isSheetPresented = true }
				)

				DefaultSelectableField<SplitOptions>(
					title: "Split Type",
					option: $trainingPreferencesModel.splitOption,
					placeholder: "Ex.: AB Split (2 Workouts)",
					selectableAction: { isSheetPresented = true }
				)

				DefaultSelectableField<ExpirienceOptions>(
					title: "Expirience Level",
					option: $trainingPreferencesModel.expirienceOption,
					placeholder: "",
					selectableAction: { isSheetPresented = true }
				)
			}
		case .extraInformations:
			Text("Ssaa")
		case .injuriesAndRestrictions:
			Text("Ssaa")
		case .helthIntegration:
			Text("Ssaa")
		}
	}
}

#Preview {
	WorkoutExpirienceCustomisation()
}
