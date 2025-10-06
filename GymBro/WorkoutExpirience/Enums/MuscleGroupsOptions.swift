import Foundation

enum MuscleGroupsOptions: String, OptionsProtocol {

	case chest
	case back
	case shoulders
	case arms
	case legs
	case core
	case gloutes

	var title: String  {
		rawValue.capitalized
	}
}
