import Foundation

/// Namespace for the Codable AI/JSON contract. Kept separate from the SwiftData
/// layer (bridged by `PlanMapper`) and from the Workouts-screen UI types
/// (`WorkoutsSession`/`WorkoutsPlan` in `WorkoutsState.swift`).
enum AIPlan {

    enum FitnessLevel: String, Codable, CaseIterable, Sendable {
        case beginner
        case intermediate
        case advanced
    }

    enum FitnessGoal: String, Codable, CaseIterable, Sendable {
        case muscleGain          = "muscle_gain"
        case fatLoss             = "fat_loss"
        case strength
        case endurance
        case flexibility
        case generalFitness      = "general_fitness"
        case athleticPerformance = "athletic_performance"
    }

    enum MuscleGroup: String, Codable, CaseIterable, Sendable {
        case chest
        case back
        case shoulders
        case biceps
        case triceps
        case forearms
        case quads
        case hamstrings
        case glutes
        case calves
        case abs
        case fullBody = "full_body"
    }

    enum Equipment: String, Codable, CaseIterable, Sendable {
        case bodyweight
        case dumbbells
        case barbell
        case kettlebell
        case resistanceBands = "resistance_bands"
        case pullupBar       = "pullup_bar"
        case cableMachine    = "cable_machine"
        case fullGym         = "full_gym"
    }

    enum SplitType: String, Codable, CaseIterable, Sendable {
        case fullBody      = "full_body"
        case upperLower    = "upper_lower"
        case pushPullLegs  = "push_pull_legs"
        case bodyPart      = "body_part"
        case custom
    }

    enum Weekday: String, Codable, CaseIterable, Sendable {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }

    enum UnitSystem: String, Codable, CaseIterable, Sendable {
        case metric
        case imperial
    }

    enum BiologicalSex: String, Codable, CaseIterable, Sendable {
        case male
        case female
        case unspecified
    }
}
