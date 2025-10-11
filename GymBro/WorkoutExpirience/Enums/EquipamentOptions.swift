import Foundation

enum EquipamentOptions:  String, OptionsProtocol {

	case bodyweight
	case dumbbells
	case barbells
	case machines

	var title: String {
		self.rawValue.capitalized
	}
}
