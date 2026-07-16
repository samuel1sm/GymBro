import Foundation

extension StatisticsState {

    /// Builds the state from the persisted plan library and workout logs.
    /// Volume is summed from logged sets (weight × reps) per Monday-first week;
    /// records and muscle frequency resolve each set's exercise through the
    /// plans, so sets whose exercise was deleted are skipped.
    init(plans: [StoredPlan], logs: [StoredWorkoutLog], today: Date = .now) {
        self.init()

        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Home's strips render Monday-first — keep weeks aligned

        let exercises = plans.flatMap { $0.sessions.flatMap(\.exercises) }
        let nameByExerciseID = Dictionary(exercises.map { ($0.id, $0.name) }) { first, _ in first }
        let musclesByExerciseID = Dictionary(exercises.map { ($0.id, $0.primaryMuscles) }) { first, _ in first }
        let sets = logs.flatMap(\.loggedSets)

        // MARK: Weekly volume

        let currentWeekStart = calendar.dateInterval(of: .weekOfYear, for: today)!.start

        weeklyVolume = (0..<Self.chartWeekCount).reversed().map { weeksBack in
            let weekStart = calendar.date(byAdding: .weekOfYear, value: -weeksBack, to: currentWeekStart)!
            let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
            let kilograms = sets
                .filter { $0.loggedAt >= weekStart && $0.loggedAt < weekEnd }
                .reduce(0.0) { $0 + $1.weightKg * Double($1.repsCompleted) }
            return VolumePoint(
                label: weekStart.formatted(.dateTime.month(.defaultDigits).day()),
                kilograms: Int(kilograms.rounded()),
                isCurrent: weeksBack == 0
            )
        }

        let current = weeklyVolume.last?.kilograms ?? 0
        let previous = weeklyVolume.dropLast().last?.kilograms ?? 0
        volumeTrendPercent = previous > 0
            ? Int((Double(current - previous) / Double(previous) * 100).rounded())
            : 0

        // MARK: Personal records

        var recordByExercise: [String: (kilograms: Double, at: Date)] = [:]
        for set in sets.sorted(by: { $0.loggedAt < $1.loggedAt }) where set.weightKg > 0 {
            guard let name = nameByExerciseID[set.exerciseId] else { continue }
            if let record = recordByExercise[name], record.kilograms >= set.weightKg { continue }
            recordByExercise[name] = (set.weightKg, set.loggedAt)
        }

        personalRecords = recordByExercise
            .sorted { $0.value.at > $1.value.at }
            .map { name, record in
                PersonalRecord(
                    exercise: name,
                    kilograms: Int(record.kilograms.rounded()),
                    achieved: "Set \(record.at.formatted(.relative(presentation: .named)))"
                )
            }

        // MARK: Muscle frequency

        var trainedDaysByGroup: [String: Set<Date>] = [:]
        for set in sets where set.loggedAt >= currentWeekStart {
            let day = calendar.startOfDay(for: set.loggedAt)
            for muscle in musclesByExerciseID[set.exerciseId] ?? [] {
                for group in Self.displayGroups(for: muscle) {
                    trainedDaysByGroup[group, default: []].insert(day)
                }
            }
        }

        muscleGroups = ["Chest", "Back", "Legs", "Shoulders", "Arms", "Core"].map { name in
            MuscleGroup(name: name, frequency: Self.frequency(forDays: trainedDaysByGroup[name]?.count ?? 0))
        }

        // MARK: Plan history

        self.plans = plans.map { plan in
            let saved = plan.savedAt.formatted(.dateTime.month(.abbreviated).day())
            let split = AIPlan.SplitType(rawValue: plan.splitType)?.displayTitle ?? plan.splitType
            return PlanHistoryItem(
                name: plan.name ?? split,
                meta: "\(saved) · \(plan.sessions.count) sessions"
            )
        }
    }

    private static let chartWeekCount = 8

    /// Folds the stored `AIPlan.MuscleGroup` raw values into the section's
    /// display groups; full-body work counts toward every group.
    private static func displayGroups(for muscle: String) -> [String] {
        switch muscle {
        case "chest":                                   ["Chest"]
        case "back":                                    ["Back"]
        case "shoulders":                               ["Shoulders"]
        case "biceps", "triceps", "forearms":           ["Arms"]
        case "quads", "hamstrings", "glutes", "calves": ["Legs"]
        case "abs":                                     ["Core"]
        case "full_body":                               ["Chest", "Back", "Legs", "Shoulders", "Arms", "Core"]
        default:                                        []
        }
    }

    private static func frequency(forDays days: Int) -> MuscleFrequency {
        switch days {
        case 0:  .none
        case 1:  .low
        case 2:  .medium
        default: .high
        }
    }
}
