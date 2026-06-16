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

/// One cell in the monthly progress grid. A `nil` `number` is a leading/trailing
/// blank used to align the first day under the correct weekday column.
struct MonthDay: Identifiable {
    let id = UUID()
    /// Day-of-month number (1…31), or `nil` for a padding cell.
    let number: Int?
    /// Training status for the day, or `nil` for a padding cell.
    let status: WeekDayStatus?
}

/// Activity-strip view mode — the strip can show the current week or the month.
enum ActivityRange: String, CaseIterable {
    case week  = "Week"
    case month = "Month"
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

    // MARK: - This month

    /// Month shown in the strip's month view (e.g. "May 2025").
    var monthLabel: String = "May 2025"

    /// Calendar grid for the current month. Leads with two blank padding cells so
    /// the 1st lands under Wednesday, matching `monthLabel`.
    var month: [MonthDay] = {
        var days: [MonthDay] = [
            MonthDay(number: nil, status: nil),
            MonthDay(number: nil, status: nil),
        ]
        // Repeating Push / Pull / Legs / Rest cadence across the month.
        let cadence: [WeekDayStatus] = [.done, .done, .missed, .done, .done, .rest, .rest]
        for n in 1...31 {
            let status: WeekDayStatus
            if n == 29 {
                status = .today
            } else if n > 29 {
                status = .future
            } else {
                status = cadence[(n - 1) % cadence.count]
            }
            days.append(MonthDay(number: n, status: status))
        }
        return days
    }()

    // MARK: - Derived

    /// Sessions completed this week.
    var doneCount: Int { week.filter { $0.status == .done }.count }

    /// Sessions planned this week (everything that isn't a rest day).
    var plannedCount: Int { week.filter { $0.status != .rest }.count }

    /// Sessions completed so far this month.
    var monthDoneCount: Int { month.filter { $0.status == .done }.count }

    /// Sessions planned this month (everything scheduled that isn't a rest day).
    var monthPlannedCount: Int {
        month.filter { $0.status != nil && $0.status != .rest }.count
    }
}
