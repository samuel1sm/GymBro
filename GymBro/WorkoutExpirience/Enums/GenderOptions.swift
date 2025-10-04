import Foundation

enum GenderOptions: String, OptionsProtocol {

	case male
	case female
	case other

	var title: String {
		rawValue.capitalized
	}
}
