import Foundation

enum BiologicalSex: String, CaseIterable {
    case male = "Male"
    case female = "Female"
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

enum FitnessLevel: String, CaseIterable {
    case beginner, intermediate, advanced

    var title: String {
        switch self {
        case .beginner:     return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced:     return "Advanced"
        }
    }

    var description: String {
        switch self {
        case .beginner:     return "New to training or returning after a long break"
        case .intermediate: return "Consistent training for 6+ months"
        case .advanced:     return "2+ years of structured, progressive programming"
        }
    }

    var meta: String {
        switch self {
        case .beginner:     return "0-6 MO"
        case .intermediate: return "6 MO – 2 YR"
        case .advanced:     return "2+ YR"
        }
    }
}

enum FitnessGoal: String, CaseIterable, Hashable {
    case muscleGain           = "Muscle Gain"
    case fatLoss              = "Fat Loss"
    case strength             = "Strength"
    case endurance            = "Endurance"
    case flexibility          = "Flexibility & Mobility"
    case generalFitness       = "General Fitness"
    case athleticPerformance  = "Athletic Performance"
}

enum EquipmentOption: String, CaseIterable, Hashable {
    case bodyweightOnly  = "Bodyweight Only"
    case dumbbells       = "Dumbbells"
    case barbellPlates   = "Barbell & Plates"
    case kettlebells     = "Kettlebells"
    case resistanceBands = "Resistance Bands"
    case pullupBar       = "Pull-up Bar"
    case cableMachine    = "Cable Machine"
    case fullGym         = "Full Commercial Gym"
}

enum InjuryArea: String, CaseIterable, Hashable {
    case lowerBack = "Lower Back"
    case knee      = "Knee"
    case shoulder  = "Shoulder"
    case wrist     = "Wrist"
    case hip       = "Hip"
    case none      = "None"
}

struct ProfileGoalsState {
    var age: Int = 28
    var weightLbs: Int = 180
    var weightKg: Int = 82
    var weightUnit: WeightUnit = .lbs
    var heightIn: Int = 70
    var heightCm: Int = 178
    var heightUnit: HeightUnit = .inches
    var sex: BiologicalSex? = .male

    var fitnessLevel: FitnessLevel = .intermediate

    var goals: [FitnessGoal] = []

    var equipment: Set<EquipmentOption> = []

    var injuryNotes: String = ""
    var injuries: Set<InjuryArea> = []

    var weightDisplay: String {
        weightUnit == .lbs ? "\(weightLbs)" : "\(weightKg)"
    }

    var heightDisplay: String {
        if heightUnit == .inches {
            return "\(heightIn / 12)' \(heightIn % 12)\""
        }
        return "\(heightCm)"
    }
}
