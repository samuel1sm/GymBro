import Foundation

extension HomeState {

    /// Builds the state from the persisted profile, plan library and workout
    /// logs. The most recently saved plan sets a weekly quota rather than fixed
    /// weekdays: any day trained counts toward the week, the remaining days are
    /// rest, and skipped days only show as missed once the week's rest budget
    /// (7 − quota) is spent. Sessions reset each week — the hero card offers
    /// the first one not yet completed this week.
    init(user: StoredUser, plans: [StoredPlan], logs: [StoredWorkoutLog], today: Date = .now) {
        self.init()

        var calendar = Calendar.current
        calendar.firstWeekday = 2 // the strips render Monday-first

        let todayStart = calendar.startOfDay(for: today)
        let activePlan = plans.first
        let sessions = activePlan?.orderedSessions ?? []

        let planner = WeekPlanner(
            quota: min(sessions.count, 7),
            completedDates: Set(logs.compactMap(\.completedAt).map { calendar.startOfDay(for: $0) }),
            planStart: activePlan.map { calendar.startOfDay(for: $0.savedAt) },
            today: todayStart,
            calendar: calendar
        )

        name = user.name ?? "GymBro"
        streak = planner.streak()

        // MARK: Today's session

        let weekStart = calendar.dateInterval(of: .weekOfYear, for: todayStart)!.start
        let completedThisWeek = Self.completedSessionIDs(in: logs, weekStart: weekStart, calendar: calendar)
        let pending = sessions.filter { !completedThisWeek.contains($0.id) }

        if let plan = activePlan,
           let session = pending.first,
           !planner.completedDates.contains(todayStart),
           planner.doneCount(inWeekOf: weekStart) < planner.quota {
            isRestDay = false
            sessionTitle = "\(session.name ?? "Training \(session.sessionNumber)") — \(session.focus)"
            sessionDetail = "\(session.exercises.count) exercises · \(session.estimatedDurationMinutes) min"
            activeSessionContext = ActiveSessionContext(planId: plan.id, sessionId: session.id)
        } else {
            isRestDay = true
            sessionTitle = ""
            sessionDetail = ""
            activeSessionContext = nil
        }

        // MARK: This week

        let focusByID = Dictionary(sessions.map { ($0.id, $0.focus) }) { first, _ in first }
        var sessionIDByDate: [Date: UUID] = [:]
        for log in logs {
            guard let completedAt = log.completedAt else { continue }
            sessionIDByDate[calendar.startOfDay(for: completedAt)] = log.sessionId
        }

        let weekStatuses = planner.statuses(weekStart: weekStart)
        plannedCount = planner.quota

        week = (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: weekStart)!
            let status = weekStatuses[offset]
            let focus: String
            switch status {
            case .done:  focus = sessionIDByDate[date].flatMap { focusByID[$0] } ?? "Rest"
            case .today: focus = pending.first?.focus ?? "Rest"
            case .future, .missed, .rest: focus = "Rest"
            }
            return WeekDay(
                letter: calendar.veryShortWeekdaySymbols[calendar.component(.weekday, from: date) - 1],
                dayNumber: calendar.component(.day, from: date),
                status: status,
                focus: focus
            )
        }

        // MARK: This month

        monthLabel = todayStart.formatted(.dateTime.month(.wide).year())

        let monthStart = calendar.dateInterval(of: .month, for: todayStart)!.start
        let dayCount = calendar.range(of: .day, in: .month, for: todayStart)!.count
        monthPlannedCount = Int((Double(dayCount * planner.quota) / 7).rounded())
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let leadingBlanks = (firstWeekday - calendar.firstWeekday + 7) % 7

        var statusesByWeek: [Date: [WeekDayStatus]] = [:]
        month = (0..<leadingBlanks).map { _ in MonthDay(number: nil, status: nil) }
        month += (0..<dayCount).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: monthStart)!
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: date)!.start
            let statuses = statusesByWeek[weekStart] ?? planner.statuses(weekStart: weekStart)
            statusesByWeek[weekStart] = statuses
            let index = calendar.dateComponents([.day], from: weekStart, to: date).day!
            return MonthDay(number: offset + 1, status: statuses[index])
        }
    }

    /// Sessions with a completed log inside the week starting at `weekStart` —
    /// these are done for the week and excluded from the pending queue.
    private static func completedSessionIDs(
        in logs: [StoredWorkoutLog],
        weekStart: Date,
        calendar: Calendar
    ) -> Set<UUID> {
        let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
        return Set(
            logs.compactMap { log in
                guard let completedAt = log.completedAt,
                      completedAt >= weekStart, completedAt < weekEnd else { return nil }
                return log.sessionId
            }
        )
    }
}

// MARK: - Weekly quota engine

/// Day-status engine for the weekly-quota model: a week holds `quota` training
/// days and `7 − quota` rest days, in no fixed order. Trained days count
/// wherever they land; skipped days consume the rest budget first and show as
/// missed once it runs out — so training 4 of 5 sessions yields exactly one
/// missed day that week. Days after today are left unmarked (`.future`) — no
/// training days are projected ahead.
private struct WeekPlanner {
    let quota: Int
    let completedDates: Set<Date>
    /// Days before the plan was saved are plain rest — never missed.
    let planStart: Date?
    let today: Date
    let calendar: Calendar

    var restBudget: Int { 7 - quota }

    func days(inWeekOf weekStart: Date) -> [Date] {
        (0..<7).map { calendar.date(byAdding: .day, value: $0, to: weekStart)! }
    }

    func doneCount(inWeekOf weekStart: Date) -> Int {
        days(inWeekOf: weekStart).count(where: completedDates.contains)
    }

    func statuses(weekStart: Date) -> [WeekDayStatus] {
        let days = days(inWeekOf: weekStart)
        let done = days.count(where: completedDates.contains)
        let todayPending = days.contains(today) && !completedDates.contains(today) && done < quota

        var restUsed = 0

        return days.map { day in
            if completedDates.contains(day) { return .done }
            guard let planStart, day >= planStart else { return .rest }
            if day == today { return todayPending ? .today : .rest }
            if day > today { return .future }
            guard restUsed < restBudget else { return .missed }
            restUsed += 1
            return .rest
        }
    }

    /// Consecutive trained days walking back from today. Rest days within the
    /// weekly budget don't break it, a missed day does, and today's
    /// still-pending session doesn't either.
    func streak() -> Int {
        guard let earliest = completedDates.min() else { return 0 }

        var statusesByWeek: [Date: [WeekDayStatus]] = [:]
        var streak = 0
        var day = today
        if !completedDates.contains(day) {
            day = calendar.date(byAdding: .day, value: -1, to: day)!
        }

        while day >= earliest {
            if completedDates.contains(day) {
                streak += 1
            } else {
                let weekStart = calendar.dateInterval(of: .weekOfYear, for: day)!.start
                let statuses = statusesByWeek[weekStart] ?? statuses(weekStart: weekStart)
                statusesByWeek[weekStart] = statuses
                let index = calendar.dateComponents([.day], from: weekStart, to: day).day!
                if statuses[index] == .missed { break }
            }
            day = calendar.date(byAdding: .day, value: -1, to: day)!
        }
        return streak
    }
}
