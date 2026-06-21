import Foundation

/// One week's training-volume data point in the weekly-volume bar chart.
struct VolumePoint: Identifiable {
    let id = UUID()
    /// Week-start label, e.g. "5/25".
    let label: String
    /// Total volume moved that week, in kilograms.
    let kilograms: Int
    /// The current (most recent) week — rendered with the full Volt accent.
    var isCurrent: Bool = false
}

/// A personal record shown in the horizontally-scrolling PR rail.
struct PersonalRecord: Identifiable {
    let id = UUID()
    /// Exercise name, e.g. "Barbell Bench".
    let exercise: String
    /// Record load, in kilograms.
    let kilograms: Int
    /// Relative recency, e.g. "Set 3 days ago".
    let achieved: String
}

/// How often a muscle group was trained this week — drives the intensity bar.
enum MuscleFrequency {
    /// Trained 3×+.
    case high
    /// Trained 2×.
    case medium
    /// Trained 1×.
    case low
    /// Not trained this week.
    case none
}

/// One muscle group in the "Muscle Frequency" intensity list.
struct MuscleGroup: Identifiable {
    let id = UUID()
    let name: String
    let frequency: MuscleFrequency
}

/// A past training plan in the "Plan History" list.
struct PlanHistoryItem: Identifiable {
    let id = UUID()
    let name: String
    /// Start date · session count, e.g. "May 26 · 5 sessions".
    let meta: String
}

/// Screen 09 — Statistics (progress & analytics).
///
/// The retention "over time" view, split off from Home. Pure data: weekly volume
/// trend, personal records, muscle frequency, plan history. No greeting, no streak
/// chip — the user comes here to reflect, not to act. Tab 3 (Stats) in the bottom
/// tab bar.
struct StatisticsState {

    // MARK: - Weekly volume

    var weeklyVolume: [VolumePoint] = [
        VolumePoint(label: "4/6",  kilograms: 10200),
        VolumePoint(label: "4/13", kilograms: 11400),
        VolumePoint(label: "4/20", kilograms: 9600),
        VolumePoint(label: "4/27", kilograms: 12600),
        VolumePoint(label: "5/4",  kilograms: 11900),
        VolumePoint(label: "5/11", kilograms: 13200),
        VolumePoint(label: "5/18", kilograms: 12700),
        VolumePoint(label: "5/25", kilograms: 14100, isCurrent: true),
    ]

    /// Week-over-week change in total volume, as a whole percentage.
    var volumeTrendPercent: Int = 11

    // MARK: - Personal records

    var personalRecords: [PersonalRecord] = [
        PersonalRecord(exercise: "Barbell Bench",    kilograms: 100, achieved: "Set 3 days ago"),
        PersonalRecord(exercise: "Deadlift",         kilograms: 180, achieved: "Set 5 days ago"),
        PersonalRecord(exercise: "Back Squat",       kilograms: 140, achieved: "Set 1 week ago"),
        PersonalRecord(exercise: "Weighted Pull-up", kilograms: 32,  achieved: "Set 2 weeks ago"),
        PersonalRecord(exercise: "Overhead Press",   kilograms: 60,  achieved: "Set 3 weeks ago"),
    ]

    // MARK: - Muscle frequency

    var muscleGroups: [MuscleGroup] = [
        MuscleGroup(name: "Chest",     frequency: .medium),
        MuscleGroup(name: "Back",      frequency: .high),
        MuscleGroup(name: "Legs",      frequency: .low),
        MuscleGroup(name: "Shoulders", frequency: .medium),
        MuscleGroup(name: "Arms",      frequency: .high),
    ]

    // MARK: - Plan history

    var plans: [PlanHistoryItem] = [
        PlanHistoryItem(name: "5-Day PPL Split", meta: "May 26 · 5 sessions"),
        PlanHistoryItem(name: "Upper / Lower",   meta: "Apr 2 · 4 sessions"),
        PlanHistoryItem(name: "Full Body",       meta: "Mar 1 · 3 sessions"),
    ]

    // MARK: - Derived

    /// The most recent week's total volume — the headline figure on the chart card.
    var currentVolumeKg: Int {
        weeklyVolume.first(where: \.isCurrent)?.kilograms
            ?? weeklyVolume.last?.kilograms
            ?? 0
    }
}
