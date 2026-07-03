import Foundation

protocol PlanCreationService: Sendable {
    func createPlan(from request: AIPlan.PlanRequest) async throws -> AIPlan.WorkoutPlan
}

/// Stand-in until the real AI backend is wired up.
struct SimulatedPlanCreationService: PlanCreationService {
    func createPlan(from request: AIPlan.PlanRequest) async throws -> AIPlan.WorkoutPlan {
        try await Task.sleep(for: .seconds(2))

        let sessions = (1...max(1, request.daysPerWeek)).map { number in
            AIPlan.WorkoutSession(
                sessionNumber: number,
                focus: "Full Body \(number)",
                suggestedDay: nil,
                estimatedDurationMinutes: request.sessionDurationMinutes,
                warmupNotes: "5 min light cardio + dynamic stretches",
                cooldownNotes: "5 min static stretching",
                exercises: [
                    AIPlan.Exercise(
                        name: "Goblet Squat",
                        equipment: .dumbbells,
                        muscles: AIPlan.MuscleGroups(primary: [.quads, .glutes], secondary: [.abs]),
                        sets: 3,
                        repsMin: 8,
                        repsMax: 12,
                        restSeconds: 90,
                        rpeTarget: 7,
                        coachingNotes: nil,
                        videoUrl: nil,
                        alternatives: []
                    ),
                    AIPlan.Exercise(
                        name: "Push-up",
                        equipment: .bodyweight,
                        muscles: AIPlan.MuscleGroups(primary: [.chest, .triceps], secondary: [.shoulders]),
                        sets: 3,
                        repsMin: 10,
                        repsMax: 15,
                        restSeconds: 60,
                        rpeTarget: 7,
                        coachingNotes: nil,
                        videoUrl: nil,
                        alternatives: []
                    )
                ]
            )
        }

        return AIPlan.WorkoutPlan(
            splitType: .fullBody,
            weeklySessionCount: sessions.count,
            planNotes: nil,
            sessions: sessions
        )
    }
}
