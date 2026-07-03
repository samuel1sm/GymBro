import Foundation

extension AIPlan.WorkoutPlan {
    /// Returns a copy where sessions missing a suggested day get one — the
    /// user's preferred training days when they cover every session,
    /// otherwise a conventional spread for that weekly session count.
    func fillingSuggestedDays(from request: AIPlan.PlanRequest?) -> AIPlan.WorkoutPlan {
        guard sessions.contains(where: { ($0.suggestedDay ?? "").isEmpty }) else { return self }

        let days = Self.defaultDays(
            preferred: request?.preferredTrainingDays ?? [],
            sessionCount: sessions.count
        )

        var plan = self
        plan.sessions = sessions.enumerated().map { index, session in
            var session = session
            if (session.suggestedDay ?? "").isEmpty, days.indices.contains(index) {
                session.suggestedDay = days[index].shortName
            }
            return session
        }
        return plan
    }

    private static func defaultDays(preferred: [AIPlan.Weekday], sessionCount: Int) -> [AIPlan.Weekday] {
        if preferred.count >= sessionCount {
            let order = AIPlan.Weekday.allCases
            return preferred.sorted {
                (order.firstIndex(of: $0) ?? 0) < (order.firstIndex(of: $1) ?? 0)
            }
        }
        switch sessionCount {
        case 1: return [.monday]
        case 2: return [.monday, .thursday]
        case 3: return [.monday, .wednesday, .friday]
        case 4: return [.monday, .wednesday, .friday, .saturday]
        case 5: return [.monday, .tuesday, .wednesday, .friday, .saturday]
        case 6: return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        default: return AIPlan.Weekday.allCases
        }
    }
}

extension AIPlan.Weekday {
    /// Three-letter display abbreviation ("Mon").
    var shortName: String { String(rawValue.prefix(3)).capitalized }
}
