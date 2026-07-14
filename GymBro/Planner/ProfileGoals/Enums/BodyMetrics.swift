import Foundation

enum BiologicalSex: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case preferNotToSay = "Prefer not to say"
}

enum WeightUnit: String, CaseIterable {
    case lbs, kg
    var label: String { rawValue.uppercased() }

    private static let kgPerLb = 0.45359237

    /// A canonical kg value in this display unit.
    func fromKg(_ kg: Double) -> Double {
        self == .lbs ? kg / Self.kgPerLb : kg
    }

    /// A value entered in this display unit back to canonical kg.
    func toKg(_ value: Double) -> Double {
        self == .lbs ? value * Self.kgPerLb : value
    }
}

enum HeightUnit: String, CaseIterable {
    case inches = "in"
    case cm
    var label: String { rawValue.uppercased() }
}
