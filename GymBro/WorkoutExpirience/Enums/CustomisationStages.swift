protocol StageFlow: RawRepresentable, Equatable, CaseIterable where RawValue == Int {

	func getNextStage() -> Self
	func getPreviousStage() -> Self
}

enum CustomisationStages: Int, StageFlow {

	case personalInformations = 1
	case trainingPreferences = 2
	case extraInformations = 3
	case injuriesAndRestrictions = 4
	case helthIntegration = 5
}

extension CustomisationStages {

	func getNextStage() -> CustomisationStages {
		.init(rawValue: self.rawValue.advanced(by: 1)) ?? .personalInformations
	}

	func getPreviousStage() -> CustomisationStages {
		.init(rawValue: self.rawValue.advanced(by: -1)) ?? .helthIntegration
	}
}
