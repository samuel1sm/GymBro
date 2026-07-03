import Foundation

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
