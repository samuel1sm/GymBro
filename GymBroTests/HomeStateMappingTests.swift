import Testing
import Foundation
@testable import GymBro

/// Tests for `HomeState`'s persistence mapping under the weekly-quota model:
/// a 3-session plan means any 3 days of the week are training days, skipped
/// days consume the 4-day rest budget before showing as missed, and sessions
/// reset each week. Plans go through `InMemoryUserStore` so the relationship
/// graph behaves like production.
@MainActor
struct HomeStateMappingTests {

    @Test
    func nextPendingSessionDrivesTheCard() throws {
        let (_, user, plan) = try Self.makeFixtures()
        let state = HomeState(user: user, plans: [plan], logs: [], today: Self.monday)

        #expect(state.name == "Sam")
        #expect(!state.isRestDay)
        #expect(state.sessionTitle == "Training 1 — Push")
        #expect(state.sessionDetail == "2 exercises · 70 min")
        #expect(state.activeSessionContext?.planId == plan.id)
        #expect(state.activeSessionContext?.sessionId == plan.orderedSessions[0].id)
    }

    @Test
    func trainingTodayOrMeetingTheQuotaRests() throws {
        let (_, user, plan) = try Self.makeFixtures()

        // Already trained today — recover.
        let trainedToday = HomeState(
            user: user,
            plans: [plan],
            logs: [Self.completedLog(for: plan.orderedSessions[0], on: Self.monday)],
            today: Self.monday
        )
        #expect(trainedToday.isRestDay)
        #expect(trainedToday.activeSessionContext == nil)

        // Quota met earlier in the week — Saturday rests even though it's untrained.
        let quotaMet = HomeState(
            user: user,
            plans: [plan],
            logs: Self.fullWeekLogs(for: plan),
            today: Self.date(2027, 1, 9)
        )
        #expect(quotaMet.isRestDay)
    }

    @Test
    func sessionsResetEachWeek() throws {
        let (_, user, plan) = try Self.makeFixtures()

        // The whole plan was completed last week — Monday offers Training 1 again.
        let state = HomeState(
            user: user,
            plans: [plan],
            logs: Self.fullWeekLogs(for: plan),
            today: Self.date(2027, 1, 11)
        )
        #expect(!state.isRestDay)
        #expect(state.sessionTitle == "Training 1 — Push")
        #expect(state.activeSessionContext?.sessionId == plan.orderedSessions[0].id)
    }

    @Test
    func weekStatusesFollowTheWeeklyQuota() throws {
        let (_, user, plan) = try Self.makeFixtures()

        // Trained Monday; Wednesday is today. 2 of 3 sessions left this week.
        let logs = [Self.completedLog(for: plan.orderedSessions[0], on: Self.monday)]
        let state = HomeState(user: user, plans: [plan], logs: logs, today: Self.date(2027, 1, 6))

        #expect(state.week.map(\.status) == [.done, .rest, .today, .future, .future, .future, .future])
        #expect(state.week.map(\.dayNumber) == [4, 5, 6, 7, 8, 9, 10])
        #expect(state.week.map(\.focus) == ["Push", "Rest", "Pull", "Rest", "Rest", "Rest", "Rest"])
        #expect(state.doneCount == 1)
        #expect(state.plannedCount == 3)          // the plan's days per week
        #expect(state.monthPlannedCount == 13)    // 31 days × 3/7, rounded

        // January 2027 starts on a Friday — 4 leading blanks, then 31 days.
        #expect(state.monthLabel == "January 2027")
        #expect(state.month.count == 4 + 31)
        #expect(state.month[4 + 3].status == .done) // Jan 4
    }

    @Test
    func missedDaysAppearOnceTheRestBudgetIsSpent() throws {
        let (_, user, plan) = try Self.makeFixtures()
        let sunday = Self.date(2027, 1, 10)

        // Nothing trained by Sunday: 4 rest days absorbed, then misses begin.
        let state = HomeState(user: user, plans: [plan], logs: [], today: sunday)
        #expect(state.week.map(\.status) == [.rest, .rest, .rest, .rest, .missed, .missed, .today])

        // A plan saved Friday can't have missed days before it existed.
        plan.savedAt = Self.date(2027, 1, 8)
        let clamped = HomeState(user: user, plans: [plan], logs: [], today: sunday)
        #expect(clamped.week.map(\.status) == [.rest, .rest, .rest, .rest, .rest, .rest, .today])
    }

    @Test
    func streakCountsTrainedDaysAndBreaksOnAMissedDay() throws {
        let (_, user, plan) = try Self.makeFixtures()

        // Last week hit the quota (Mon / Wed / Fri) — today's pending Monday
        // doesn't break the streak.
        let fullWeek = [
            Self.completedLog(for: plan.orderedSessions[0], on: Self.date(2026, 12, 28)),
            Self.completedLog(for: plan.orderedSessions[1], on: Self.date(2026, 12, 30)),
            Self.completedLog(for: plan.orderedSessions[2], on: Self.date(2027, 1, 1)),
        ]
        let pending = HomeState(user: user, plans: [plan], logs: fullWeek, today: Self.monday)
        #expect(pending.streak == 3)

        // Completing today extends it.
        let done = HomeState(
            user: user,
            plans: [plan],
            logs: fullWeek + [Self.completedLog(for: plan.orderedSessions[0], on: Self.monday)],
            today: Self.monday
        )
        #expect(done.streak == 4)

        // One session short last week — its final day is a miss, streak resets.
        let shortWeek = Array(fullWeek.prefix(2))
        let broken = HomeState(user: user, plans: [plan], logs: shortWeek, today: Self.monday)
        #expect(broken.streak == 0)
    }
}

// MARK: - Fixtures

extension HomeStateMappingTests {

    /// Monday, far enough ahead that the plan's `savedAt` (now) precedes it.
    private static var monday: Date { date(2027, 1, 4) }

    private static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
    }

    private static func completedLog(for session: StoredSession, on day: Date) -> StoredWorkoutLog {
        StoredWorkoutLog(
            planId: session.plan?.id ?? UUID(),
            sessionId: session.id,
            startedAt: day,
            completedAt: day
        )
    }

    /// All three sessions completed Mon / Wed / Fri of the week of Jan 4 2027.
    private static func fullWeekLogs(for plan: StoredPlan) -> [StoredWorkoutLog] {
        [
            completedLog(for: plan.orderedSessions[0], on: date(2027, 1, 4)),
            completedLog(for: plan.orderedSessions[1], on: date(2027, 1, 6)),
            completedLog(for: plan.orderedSessions[2], on: date(2027, 1, 8)),
        ]
    }

    /// The store is returned so its container outlives the models under test.
    private static func makeFixtures() throws -> (InMemoryUserStore, StoredUser, StoredPlan) {
        let store = try InMemoryUserStore()
        let user = try store.saveUser(PersistenceTests.sampleRequest)
        try store.savePlan(Self.plan, for: user, name: "Test Plan")
        let plan = try #require(try store.loadSavedPlans(for: user).first)
        return (store, user, plan)
    }

    /// Three sessions a week — a 4-day rest budget.
    private static var plan: AIPlan.WorkoutPlan {
        AIPlan.WorkoutPlan(
            splitType: .pushPullLegs,
            weeklySessionCount: 3,
            planNotes: nil,
            sessions: [
                session(number: 1, focus: "Push", minutes: 70),
                session(number: 2, focus: "Pull", minutes: 65),
                session(number: 3, focus: "Legs", minutes: 60),
            ]
        )
    }

    private static func session(number: Int, focus: String, minutes: Int) -> AIPlan.WorkoutSession {
        AIPlan.WorkoutSession(
            sessionNumber: number,
            focus: focus,
            suggestedDay: nil,
            estimatedDurationMinutes: minutes,
            warmupNotes: nil,
            cooldownNotes: nil,
            exercises: [exercise, exercise]
        )
    }

    private static var exercise: AIPlan.Exercise {
        AIPlan.Exercise(
            name: "Barbell Bench Press",
            equipment: .barbell,
            muscles: AIPlan.MuscleGroups(primary: [.chest], secondary: []),
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
