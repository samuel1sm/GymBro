import Testing
import SwiftData
import Foundation
@testable import GymBro

/// Tests for the SwiftData persistence layer + `PlanMapper`. Everything runs
/// against an in-memory container via `InMemoryUserStore`.
@MainActor
struct PersistenceTests {

    // MARK: - loadUser lifecycle

    @Test
    func loadUserReturnsNilOnFreshContainerThenSavedUser() throws {
        let store = try InMemoryUserStore()

        #expect(try store.loadUser() == nil)

        let request = Self.sampleRequest
        let saved = try store.saveUser(request)

        let loaded = try store.loadUser()
        #expect(loaded != nil)
        #expect(loaded?.id == saved.id)
        #expect(loaded?.name == request.name)
        #expect(loaded?.goals == request.goals.map(\.rawValue))
        #expect(loaded?.availableEquipment == request.availableEquipment.map(\.rawValue))
        #expect(loaded?.preferredSplit == request.preferredSplit.rawValue)
    }

    @Test
    func saveUserUpdatesInPlaceRatherThanCreatingASecond() throws {
        let store = try InMemoryUserStore()
        let first = try store.saveUser(Self.sampleRequest)

        var edited = Self.sampleRequest
        let newBirthDate = Date(timeIntervalSince1970: 473_385_600) // 1985-01-01
        edited.birthDate = newBirthDate
        edited.daysPerWeek = 6
        let second = try store.saveUser(edited)

        #expect(first.id == second.id)                          // same record
        #expect(try store.loadUser()?.birthDate == newBirthDate) // updated
    }

    // MARK: - Plan graph round-trip through storage

    @Test
    func savePlanPersistsFullGraphAcrossAFreshContext() throws {
        let store = try InMemoryUserStore()
        let user = try store.saveUser(Self.sampleRequest)
        try store.savePlan(Self.samplePlan, for: user, name: "My Plan")

        // Re-fetch through a brand-new context on the same container to prove the
        // graph genuinely persisted (not just in-memory object identity).
        let freshContext = ModelContext(store.container)
        let fetched = try freshContext.fetch(FetchDescriptor<StoredPlan>())
        #expect(fetched.count == 1)

        let plan = try #require(fetched.first)
        #expect(plan.name == "My Plan")
        #expect(plan.splitType == Self.samplePlan.splitType.rawValue)
        #expect(plan.orderedSessions.count == Self.samplePlan.sessions.count)

        // Session 1 -> exercises in order -> first exercise's alternatives.
        let session1 = plan.orderedSessions[0]
        #expect(session1.sessionNumber == 1)
        #expect(session1.warmupNotes == "5 min row")
        #expect(session1.orderedExercises.count == 2)

        let bench = session1.orderedExercises[0]
        #expect(bench.name == "Barbell Bench Press")
        #expect(bench.orderIndex == 0)
        #expect(bench.sets == 4)
        #expect(bench.primaryMuscles == [AIPlan.MuscleGroup.chest.rawValue])
        #expect(bench.orderedAlternatives.count == 1)
        #expect(bench.orderedAlternatives[0].name == "Dumbbell Bench Press")
    }

    @Test
    func loadSavedPlansReturnsThePlansSavedForAUser() throws {
        let store = try InMemoryUserStore()
        let user = try store.saveUser(Self.sampleRequest)
        try store.savePlan(Self.samplePlan, for: user, name: "Plan A")

        let plans = try store.loadSavedPlans(for: user)
        #expect(plans.count == 1)
        #expect(plans[0].name == "Plan A")
    }

    @Test
    func deletePlanCascadesAndLeavesNoOrphans() throws {
        let store = try InMemoryUserStore()
        let user = try store.saveUser(Self.sampleRequest)
        try store.savePlan(Self.samplePlan, for: user, name: "Plan A")

        let plan = try #require(try store.loadSavedPlans(for: user).first)
        try store.deletePlan(plan)

        let context = ModelContext(store.container)
        #expect(try context.fetch(FetchDescriptor<StoredPlan>()).isEmpty)
        #expect(try context.fetch(FetchDescriptor<StoredSession>()).isEmpty)
        #expect(try context.fetch(FetchDescriptor<StoredExercise>()).isEmpty)
        #expect(try context.fetch(FetchDescriptor<StoredAlternative>()).isEmpty)
    }

    // MARK: - PlanMapper round-trip (no storage)

    @Test
    func planMapperRoundTripPreservesData() throws {
        let original = Self.samplePlan
        let stored = PlanMapper.toStored(plan: original, request: Self.sampleRequest, name: "X")
        let rebuilt = PlanMapper.toAIPlan(stored: stored)

        // AIPlan models carry no ids/dates, so equality is exact.
        #expect(rebuilt == original)
    }

    @Test
    func userMapperRoundTripPreservesData() throws {
        let original = Self.sampleRequest
        let user = PlanMapper.makeUser(from: original)
        let rebuilt = PlanMapper.toRequest(user)

        #expect(rebuilt == original)
    }

    // MARK: - Logging seam: upsert-by-id

    @Test
    func upsertLoggedSetsUpdatesByIdInsteadOfDuplicating() throws {
        let store = try InMemoryUserStore()
        let user = try store.saveUser(Self.sampleRequest)
        let log = try store.startWorkoutLog(planId: UUID(), sessionId: UUID(), for: user)

        let exerciseId = UUID()
        let setId = UUID()

        // First delivery (e.g. logged on phone).
        let first = StoredLoggedSet(
            id: setId,
            exerciseId: exerciseId,
            setIndex: 0,
            weightKg: 100,
            repsCompleted: 8,
            rpe: 7,
            deviceOrigin: .phone
        )
        try store.upsertLoggedSets([first], into: log)
        #expect(log.loggedSets.count == 1)

        // Second delivery with the SAME id (e.g. watch resend) — must update.
        let resend = StoredLoggedSet(
            id: setId,
            exerciseId: exerciseId,
            setIndex: 0,
            weightKg: 110,
            repsCompleted: 10,
            rpe: 8,
            deviceOrigin: .watch
        )
        try store.upsertLoggedSets([resend], into: log)

        #expect(log.loggedSets.count == 1)   // not duplicated
        let merged = try #require(log.loggedSets.first)
        #expect(merged.id == setId)
        #expect(merged.weightKg == 110)
        #expect(merged.repsCompleted == 10)
        #expect(merged.rpe == 8)
        #expect(merged.deviceOrigin == .watch)

        // A genuinely new id is added alongside, not merged.
        let another = StoredLoggedSet(
            id: UUID(),
            exerciseId: exerciseId,
            setIndex: 1,
            weightKg: 110,
            repsCompleted: 9,
            deviceOrigin: .watch
        )
        try store.upsertLoggedSets([another], into: log)
        #expect(log.loggedSets.count == 2)
    }

    @Test
    func loadLogsReturnsLogsForUser() throws {
        let store = try InMemoryUserStore()
        let user = try store.saveUser(Self.sampleRequest)
        _ = try store.startWorkoutLog(planId: UUID(), sessionId: UUID(), for: user)

        let logs = try store.loadLogs(for: user)
        #expect(logs.count == 1)
    }
}

// MARK: - Fixtures

extension PersistenceTests {

    static var sampleRequest: AIPlan.PlanRequest {
        AIPlan.PlanRequest(
            name: "Sam",
            birthDate: Date(timeIntervalSince1970: 883_612_800), // 1998-01-01

            sex: .male,
            weightKg: 82,
            heightCm: 178,
            unitSystem: .metric,
            fitnessLevel: .intermediate,
            goals: [.muscleGain, .strength],
            focusMuscleGroups: [.chest, .back],
            availableEquipment: [.barbell, .dumbbells, .cableMachine],
            injuriesAndLimitations: "Mild lower-back sensitivity",
            daysPerWeek: 5,
            sessionDurationMinutes: 70,
            preferredSplit: .pushPullLegs
        )
    }

    static var samplePlan: AIPlan.WorkoutPlan {
        AIPlan.WorkoutPlan(
            splitType: .pushPullLegs,
            weeklySessionCount: 2,
            planNotes: "Progressive overload week to week.",
            sessions: [
                AIPlan.WorkoutSession(
                    sessionNumber: 1,
                    focus: "Push",
                    suggestedDay: "Monday",
                    estimatedDurationMinutes: 70,
                    warmupNotes: "5 min row",
                    cooldownNotes: "Chest stretch",
                    exercises: [
                        AIPlan.Exercise(
                            name: "Barbell Bench Press",
                            equipment: .barbell,
                            muscles: AIPlan.MuscleGroups(primary: [.chest], secondary: [.triceps, .shoulders]),
                            sets: 4,
                            repsMin: 6,
                            repsMax: 8,
                            restSeconds: 120,
                            rpeTarget: 8,
                            coachingNotes: "Retract scapula.",
                            videoUrl: "https://example.com/bench",
                            alternatives: [
                                AIPlan.AlternativeExercise(
                                    name: "Dumbbell Bench Press",
                                    equipment: .dumbbells,
                                    muscles: AIPlan.MuscleGroups(primary: [.chest], secondary: [.triceps]),
                                    coachingNotes: "Neutral grip option.",
                                    videoUrl: nil
                                )
                            ]
                        ),
                        AIPlan.Exercise(
                            name: "Cable Fly",
                            equipment: .cableMachine,
                            muscles: AIPlan.MuscleGroups(primary: [.chest], secondary: []),
                            sets: 3,
                            repsMin: 12,
                            repsMax: 15,
                            restSeconds: 60,
                            rpeTarget: nil,
                            coachingNotes: nil,
                            videoUrl: nil,
                            alternatives: []
                        ),
                    ]
                ),
                AIPlan.WorkoutSession(
                    sessionNumber: 2,
                    focus: "Pull",
                    suggestedDay: "Wednesday",
                    estimatedDurationMinutes: 65,
                    warmupNotes: nil,
                    cooldownNotes: nil,
                    exercises: [
                        AIPlan.Exercise(
                            name: "Deadlift",
                            equipment: .barbell,
                            muscles: AIPlan.MuscleGroups(primary: [.back, .hamstrings], secondary: [.glutes]),
                            sets: 3,
                            repsMin: 3,
                            repsMax: 5,
                            restSeconds: 180,
                            rpeTarget: 9,
                            coachingNotes: "Brace hard.",
                            videoUrl: nil,
                            alternatives: []
                        )
                    ]
                ),
            ]
        )
    }
}
