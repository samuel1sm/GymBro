import Foundation

/// Per-day status in the "This Week" strip, under the weekly-quota model: any
/// day trained counts, untrained days consume the week's rest budget, and days
/// beyond it are missed.
enum WeekDayStatus {
    /// A day the user trained.
    case done
    /// Today, with a session still open.
    case today
    /// An untrained day after the week's rest budget ran out.
    case missed
    /// An untrained day within the week's rest budget.
    case rest
    /// A day that hasn't happened yet — nothing is projected ahead.
    case future
}

/// One day in the weekly progress strip.
struct WeekDay: Identifiable {
    let id = UUID()
    /// Single-letter day initial (M, T, W, …).
    let letter: String
    /// Day-of-month number (1…31).
    let dayNumber: Int
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
/// The placeholder values below keep previews working; `HomeViewModel.load(from:)`
/// replaces them with the persisted profile, plan and logs.
struct HomeState {

    // MARK: - Identity

    var name: String = "Alex"
    var streak: Int = 12

    // MARK: - Today's session

    var isRestDay: Bool = false
    var sessionTitle: String = "Training 3 — Pull Day"
    var sessionDetail: String = "6 exercises · 60 min"

    /// Identity of today's session in the saved plan — what Start Workout
    /// pushes to the active session. Nil until loaded from persistence.
    var activeSessionContext: ActiveSessionContext?

    // MARK: - This week

    var week: [WeekDay] = [
        WeekDay(letter: "M", dayNumber: 25, status: .done,   focus: "Push"),
        WeekDay(letter: "T", dayNumber: 26, status: .done,   focus: "Pull"),
        WeekDay(letter: "W", dayNumber: 27, status: .missed, focus: "Legs"),
        WeekDay(letter: "T", dayNumber: 28, status: .done,   focus: "Push"),
        WeekDay(letter: "F", dayNumber: 29, status: .today,  focus: "Pull"),
        WeekDay(letter: "S", dayNumber: 30, status: .rest,   focus: "Rest"),
        WeekDay(letter: "S", dayNumber: 31, status: .rest,   focus: "Rest"),
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

    /// The weekly session target — the days per week the user's plan trains.
    var plannedCount: Int = 5

    /// Sessions completed so far this month.
    var monthDoneCount: Int { month.filter { $0.status == .done }.count }

    /// The month's session target — the weekly target scaled to the month's length.
    var monthPlannedCount: Int = 22
}
