import Foundation

enum SexOptions: String, OptionsProtocol {

	case male
	case female
	case other

	var title: String {
		rawValue.capitalized
	}
}
