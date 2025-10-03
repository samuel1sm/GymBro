import Foundation

enum ExpirienceOptions: String, OptionsProtocol {

	case begginer
	case advanced

	var title: String {
		self.rawValue.capitalized
	}
}
