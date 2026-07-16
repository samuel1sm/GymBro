import Testing
import Foundation
@testable import GymBro

/// Tests for `StatisticsState`'s persistence mapping: weekly volume summed
/// from logged sets, personal records as the heaviest set per exercise name,
/// muscle frequency as distinct training days this week, and plan history.
/// Logs go through `InMemoryUserStore` so the relationship graph behaves like
/// production.
@MainActor
struct StatisticsStateMappingTests {

    @Test
    func weeklyVolumeSumsSetsPerWeek() throws {
        let (store, user, plan) = try Self.makeFixtures()
        try Self.logSampleWorkouts(for: plan, user: user, store: store)
        let state = try Self.makeState(store: store, user: user)

        #expect(state.weeklyVolume.count == 8)
        #expect(state.weeklyVolume.last?.isCurrent == true)
        // Formatted with the same locale-dependent style the mapping uses —
        // this pins the last bar to the week starting Monday Jan 4.
        let currentWeekLabel = Self.date(2027, 1, 4).formatted(.dateTime.month(.defaultDigits).day())
        #expect(state.weeklyVolume.last?.label == currentWeekLabel)
        #expect(state.weeklyVolume.last?.kilograms == 2200)   // 600 + 700 + 200 + 700
        #expect(state.weeklyVolume[6].kilograms == 2000)      // previous week: 2 × 100 kg × 10
        #expect(state.currentVolumeKg == 2200)
        #expect(state.volumeTrendPercent == 10)
    }

    @Test
    func emptyPreviousWeekYieldsZeroTrend() throws {
        let (store, user, plan) = try Self.makeFixtures()
        let bench = plan.orderedSessions[0].orderedExercises[0]
        try store.saveCompletedWorkout(
            planId: plan.id,
            sessionId: plan.orderedSessions[0].id,
            startedAt: Self.date(2027, 1, 4),
            completedAt: Self.date(2027, 1, 4),
            sets: [StoredLoggedSet(exerciseId: bench.id, setIndex: 0, weightKg: 100, repsCompleted: 10, loggedAt: Self.date(2027, 1, 4))],
            for: user
        )
        let state = try Self.makeState(store: store, user: user)

        #expect(state.volumeTrendPercent == 0)
    }

    @Test
    func personalRecordsKeepTheHeaviestSetPerExercise() throws {
        let (store, user, plan) = try Self.makeFixtures()
        try Self.logSampleWorkouts(for: plan, user: user, store: store)
        let state = try Self.makeState(store: store, user: user)

        let byName = Dictionary(uniqueKeysWithValues: state.personalRecords.map { ($0.exercise, $0) })
        #expect(byName["Bench Press"]?.kilograms == 120)
        #expect(byName["Back Squat"]?.kilograms == 140)
        #expect(byName["Biceps Curl"]?.kilograms == 20)
        #expect(byName["Plank"] == nil) // bodyweight sets never set a record
        #expect(state.personalRecords.allSatisfy { $0.achieved.hasPrefix("Set ") })
    }

    @Test
    func muscleFrequencyCountsDistinctTrainingDaysThisWeek() throws {
        let (store, user, plan) = try Self.makeFixtures()
        try Self.logSampleWorkouts(for: plan, user: user, store: store)
        let state = try Self.makeState(store: store, user: user)

        let byName = Dictionary(uniqueKeysWithValues: state.muscleGroups.map { ($0.name, $0.frequency) })
        #expect(byName["Chest"] == .medium)    // bench on Mon and Wed
        #expect(byName["Legs"] == .low)        // squat on Mon
        #expect(byName["Arms"] == .low)        // curl on Mon
        #expect(byName["Core"] == .low)        // plank on Wed
        #expect(byName["Back"] == MuscleFrequency.none)
        #expect(byName["Shoulders"] == MuscleFrequency.none)
    }

    @Test
    func planHistoryListsSavedPlans() throws {
        let (store, user, _) = try Self.makeFixtures()
        let state = try Self.makeState(store: store, user: user)

        #expect(state.plans.count == 1)
        #expect(state.plans[0].name == "Test Plan")
        #expect(state.plans[0].meta.hasSuffix("· 1 sessions"))
    }
}

// MARK: - Fixtures

extension StatisticsStateMappingTests {

    /// Wednesday in the week of Monday Jan 4 2027.
    private static var today: Date { date(2027, 1, 6) }

    private static func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 12) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
    }

    private static func makeState(store: InMemoryUserStore, user: StoredUser) throws -> StatisticsState {
        StatisticsState(
            plans: try store.loadSavedPlans(for: user),
            logs: try store.loadLogs(for: user),
            today: today
        )
    }

    /// One set on Monday of the previous week, then two workouts this week:
    /// Monday (bench PR 120, squat 140, curl 20) and Wednesday (bench 100 ×7,
    /// bodyweight plank).
    private static func logSampleWorkouts(for plan: StoredPlan, user: StoredUser, store: InMemoryUserStore) throws {
        let session = plan.orderedSessions[0]
        let exercises = session.orderedExercises
        let (bench, squat, curl, plank) = (exercises[0], exercises[1], exercises[2], exercises[3])

        func log(on day: Date, sets: [StoredLoggedSet]) throws {
            try store.saveCompletedWorkout(
                planId: plan.id,
                sessionId: session.id,
                startedAt: day,
                completedAt: day,
                sets: sets,
                for: user
            )
        }

        let lastMonday = date(2026, 12, 28)
        try log(on: lastMonday, sets: [
            StoredLoggedSet(exerciseId: bench.id, setIndex: 0, weightKg: 100, repsCompleted: 10, loggedAt: lastMonday),
            StoredLoggedSet(exerciseId: bench.id, setIndex: 1, weightKg: 100, repsCompleted: 10, loggedAt: lastMonday),
        ])

        let monday = date(2027, 1, 4)
        try log(on: monday, sets: [
            StoredLoggedSet(exerciseId: bench.id, setIndex: 0, weightKg: 120, repsCompleted: 5, loggedAt: monday),
            StoredLoggedSet(exerciseId: squat.id, setIndex: 0, weightKg: 140, repsCompleted: 5, loggedAt: monday),
            StoredLoggedSet(exerciseId: curl.id, setIndex: 0, weightKg: 20, repsCompleted: 10, loggedAt: monday),
        ])

        let wednesday = date(2027, 1, 6)
        try log(on: wednesday, sets: [
            StoredLoggedSet(exerciseId: bench.id, setIndex: 0, weightKg: 100, repsCompleted: 7, loggedAt: wednesday),
            StoredLoggedSet(exerciseId: plank.id, setIndex: 0, weightKg: 0, repsCompleted: 1, loggedAt: wednesday),
        ])
    }

    /// The store is returned so its container outlives the models under test.
    private static func makeFixtures() throws -> (InMemoryUserStore, StoredUser, StoredPlan) {
        let store = try InMemoryUserStore()
        let user = try store.saveUser(PersistenceTests.sampleRequest)
        try store.savePlan(Self.plan, for: user, name: "Test Plan")
        let plan = try #require(try store.loadSavedPlans(for: user).first)
        return (store, user, plan)
    }

    private static var plan: AIPlan.WorkoutPlan {
        AIPlan.WorkoutPlan(
            splitType: .fullBody,
            weeklySessionCount: 3,
            planNotes: nil,
            sessions: [
                AIPlan.WorkoutSession(
                    sessionNumber: 1,
                    focus: "Full Body",
                    suggestedDay: nil,
                    estimatedDurationMinutes: 60,
                    warmupNotes: nil,
                    cooldownNotes: nil,
                    exercises: [
                        exercise("Bench Press", primary: .chest),
                        exercise("Back Squat", primary: .quads),
                        exercise("Biceps Curl", primary: .biceps),
                        exercise("Plank", primary: .abs),
                    ]
                )
            ]
        )
    }

    private static func exercise(_ name: String, primary: AIPlan.MuscleGroup) -> AIPlan.Exercise {
        AIPlan.Exercise(
            name: name,
            equipment: .barbell,
            muscles: AIPlan.MuscleGroups(primary: [primary], secondary: []),
            sets: 3,
            repsMin: 8,
            repsMax: 10,
            restSeconds: 90,
            rpeTarget: nil,
            coachingNotes: nil,
            videoUrl: nil,
            alternatives: []
        )
    }
}
