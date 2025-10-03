enum TrainingDaysPerWeekOptions: String, OptionsProtocol {

	case one
	case two
	case three
	case four
	case five
	case six
	case seven

	var title: String {
		switch self {
		case .one: return "One day"
		case .two: return "Two days"
		case .three: return "Three days"
		case .four: return "Four days"
		case .five: return "Five days"
		case .six: return "Six days"
		case .seven: return "Seven days"
		}
	}
}
