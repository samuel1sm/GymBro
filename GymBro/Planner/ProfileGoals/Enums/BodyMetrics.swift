import Foundation

enum BiologicalSex: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case preferNotToSay = "Prefer not to say"
}

enum WeightUnit: String, CaseIterable {
    case lbs, kg
    var label: String { rawValue.uppercased() }
}

enum HeightUnit: String, CaseIterable {
    case inches = "in"
    case cm
    var label: String { rawValue.uppercased() }
}
