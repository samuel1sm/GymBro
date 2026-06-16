import Foundation

/// Per-day status in the "This Week" strip.
enum WeekDayStatus {
    /// Completed session.
    case done
    /// Today's planned session (still open).
    case today
    /// A planned session that was skipped.
    case missed
    /// A scheduled rest day.
    case rest
    /// A planned session later this week.
    case future
}

/// One day in the weekly progress strip.
struct WeekDay: Identifiable {
    let id = UUID()
    /// Single-letter day initial (M, T, W, …).
    let letter: String
    let status: WeekDayStatus
    /// Short training label (Push / Pull / Legs / Rest).
    let focus: String
}

/// Screen 07 — Home (action-focused landing).
///
/// The app's main view on every launch: greeting, today's session, this week.
/// Stays short and decisive — progress analytics live on the Statistics screen.
struct HomeState {

    // MARK: - Identity

    var name: String = "Alex"
    var streak: Int = 12

    // MARK: - Today's session

    var isRestDay: Bool = false
    var sessionTitle: String = "Training 3 — Pull Day"
    var sessionDetail: String = "6 exercises · 60 min"

    // MARK: - This week

    var week: [WeekDay] = [
        WeekDay(letter: "M", status: .done,   focus: "Push"),
        WeekDay(letter: "T", status: .done,   focus: "Pull"),
        WeekDay(letter: "W", status: .missed, focus: "Legs"),
        WeekDay(letter: "T", status: .done,   focus: "Push"),
        WeekDay(letter: "F", status: .today,  focus: "Pull"),
        WeekDay(letter: "S", status: .rest,   focus: "Rest"),
        WeekDay(letter: "S", status: .rest,   focus: "Rest"),
    ]

    // MARK: - Derived

    /// Sessions completed this week.
    var doneCount: Int { week.filter { $0.status == .done }.count }

    /// Sessions planned this week (everything that isn't a rest day).
    var plannedCount: Int { week.filter { $0.status != .rest }.count }
}
