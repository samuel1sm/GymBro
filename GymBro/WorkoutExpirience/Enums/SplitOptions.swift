enum SplitOptions: String, OptionsProtocol {

	case ab
	case abc
	case abcd
	case abcde

	var title: String {
		switch self {
		case .ab: "AB split (2 workouts)"
		case .abc: "ABC split (3 workouts)"
		case .abcd: "ABCD split (4 workouts)"
		case .abcde: "ABCDE split (5 workouts)"
		}
	}
}
