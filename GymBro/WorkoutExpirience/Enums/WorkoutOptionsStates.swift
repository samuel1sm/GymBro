enum WorkoutOptionsStates {

	case gender
	case trainingDaysPerWeek
	case split
	case expirience

	var title: String {
		switch self {
		case .gender: "Select your gender"
		case .trainingDaysPerWeek: "Select your training days"
		case .split: "Select your split"
		case .expirience: "Select your expirience Level"
		}
	}

	var optionType: any OptionsProtocol.Type {
		switch self {
		case .gender: GenderOptions.self
		case .trainingDaysPerWeek: TrainingDaysPerWeekOptions.self
		case .split: SplitOptions.self
		case .expirience: ExpirienceOptions.self
		}
	}
}
