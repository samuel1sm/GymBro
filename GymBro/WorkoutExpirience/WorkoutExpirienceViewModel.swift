import SwiftUI
import Observation

@MainActor
@Observable final class WorkoutExpirienceViewModel {

	var stage: CustomisationStages = .extraInformations
	var selectedOption: WorkoutOptionsStates? = nil


	var data = WorkoutExpirienceData()


	func nextStage() {
		stage = stage.getNextStage()
	}

	func backStage() {
		stage = stage.getPreviousStage()
	}

	func createPlan() {
		print("criando plano")
	}

    // Business logic
    func saveSelectedOption(_ option: any OptionsProtocol) {
        switch selectedOption {
        case .gender:
            data.personal.gender = GenderOptions(rawValue: option.rawValue)
        case .trainingDaysPerWeek:
            data.training.trainingOption = .init(rawValue: option.rawValue) ?? .two
        case .split:
            data.training.splitOption = .init(rawValue: option.rawValue) ?? .ab
        case .expirience:
            data.training.expirienceOption = .init(rawValue: option.rawValue) ?? .begginer
        case nil: break
        }
        selectedOption = nil
    }
}
