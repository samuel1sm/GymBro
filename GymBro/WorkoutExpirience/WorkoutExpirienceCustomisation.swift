import SwiftUI

struct WorkoutExpirienceCustomisation: View {

	@State private var stage: CustomisationStages = .trainingPreferences
	@State private var selectedOption: WorkoutOptionsStates? = nil
	@State private var personalModel = PersonalInformationModel()
	@State private var trainingPreferencesModel = TrainingPreferencesModel()
	@State private var sheetHeight: CGFloat = 0

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
					withAnimation(nil) {
						stage = stage.getPreviousStage()
					}
				} label: {
					Text("Back")
				}
				.buttonStyle(.borderedStyle)

				Spacer()

				Button {
					withAnimation(nil) {
						stage = stage.getNextStage()
					}
				} label: {
					Text("Next")
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
			isPresented: .constant(selectedOption != nil),
			onDismiss: {
				selectedOption = nil
				sheetHeight = 0
			}) {
			let cases: [any OptionsProtocol] = selectedOption?.optionType.allCases as? [any OptionsProtocol] ?? []
			VStack(spacing: 16) {
				Text(selectedOption?.title ?? "").font(.title2)
				Spacer()
				ForEach(Array(cases.enumerated()), id: \.offset) { _, option in
					Button {
						saveSelectedOption(option)
						selectedOption = nil
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
		switch stage {
		case .personalInformations:
			PersonalInformationView(
				model: $personalModel,
				onTapGender: {
					selectedOption = .gender
				}
			)
		case .trainingPreferences:
			TrainingPreferenceView(
				model: $trainingPreferencesModel
			) { option in
				selectedOption = option
			}
		case .extraInformations:
			Text("Ssaa")
		case .injuriesAndRestrictions:
			Text("Ssaa")
		case .helthIntegration:
			Text("Ssaa")
		}
	}

	private func saveSelectedOption(_ option: any OptionsProtocol) {
		switch selectedOption {
		case .gender:
			personalModel.gender = GenderOptions(rawValue: option.rawValue)
		case .trainingDaysPerWeek:
			trainingPreferencesModel.trainingOption = .init(rawValue: option.rawValue) ?? .two
		case .split:
			trainingPreferencesModel.splitOption = .init(rawValue: option.rawValue) ?? .ab
		case .expirience:
			trainingPreferencesModel.expirienceOption = .init(rawValue: option.rawValue) ?? .begginer
		case nil: return
		}
	}
}

#Preview {
	WorkoutExpirienceCustomisation()
}
