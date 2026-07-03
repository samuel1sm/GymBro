import Foundation

// MARK: - Models

/// One exercise under review. Wraps the generated `AIPlan.Exercise` so the
/// fields the review UI doesn't surface (equipment, alternatives, coaching
/// notes…) survive the round trip; the editable specs live alongside as
/// display text and fold back into the source via `edited`.
struct PlannerExercise: Identifiable, Hashable {
    let id: UUID = UUID()
    var source: AIPlan.Exercise
    var sets: Int
    var repsText: String
    var restText: String

    init(source: AIPlan.Exercise) {
        self.source = source
        self.sets = source.sets
        self.repsText = source.repsMin == source.repsMax
            ? "\(source.repsMin)"
            : "\(source.repsMin)–\(source.repsMax)"
        self.restText = "\(source.restSeconds)s"
    }

    var name: String { source.name }

    var muscles: String {
        source.muscles.primary.map(\.plannerTitle).joined(separator: " · ")
    }

    /// The source exercise with the edited specs parsed back in. Text that
    /// doesn't parse keeps the generated values.
    var edited: AIPlan.Exercise {
        var exercise = source
        exercise.sets = sets
        let reps = repsText.split(whereSeparator: { !$0.isNumber }).compactMap { Int($0) }
        if let first = reps.first {
            exercise.repsMin = first
            exercise.repsMax = reps.count > 1 ? max(first, reps[1]) : first
        }
        if let rest = Int(restText.filter(\.isNumber)) {
            exercise.restSeconds = rest
        }
        return exercise
    }
}

/// One training slot under review, wrapping a generated `AIPlan.WorkoutSession`.
struct PlannerTrainingSlot: Identifiable, Hashable {
    let id: UUID = UUID()
    var source: AIPlan.WorkoutSession
    var exercises: [PlannerExercise]

    init(source: AIPlan.WorkoutSession) {
        self.source = source
        self.exercises = source.exercises.map(PlannerExercise.init)
    }

    var name: String { "Training \(source.sessionNumber)" }
    var focus: String { source.focus }
    var estimatedMinutes: Int { source.estimatedDurationMinutes }

    var date: String {
        guard let day = source.suggestedDay, !day.isEmpty else { return "—" }
        return String(day.prefix(3)).capitalized
    }

    /// Rebuilds the session with all edits applied, renumbered to `number`
    /// so removals elsewhere keep the sequence contiguous.
    func edited(number: Int) -> AIPlan.WorkoutSession {
        var session = source
        session.sessionNumber = number
        session.exercises = exercises.map(\.edited)
        return session
    }
}

// MARK: - State

/// The generated plan exploded into editable review slots. `buildPlan()`
/// reassembles an `AIPlan.WorkoutPlan` with every review edit applied.
struct PlannerReviewState {
    var splitType: AIPlan.SplitType
    var planNotes: String?
    var slots: [PlannerTrainingSlot]

    init(plan: AIPlan.WorkoutPlan) {
        splitType = plan.splitType
        planNotes = plan.planNotes
        slots = plan.sessions.map(PlannerTrainingSlot.init)
    }

    func buildPlan() -> AIPlan.WorkoutPlan {
        AIPlan.WorkoutPlan(
            splitType: splitType,
            weeklySessionCount: slots.count,
            planNotes: planNotes,
            sessions: slots.enumerated().map { index, slot in
                slot.edited(number: index + 1)
            }
        )
    }
}

// MARK: - Display helpers

extension AIPlan.MuscleGroup {
    /// Short display name used on planner cards.
    var plannerTitle: String {
        self == .fullBody ? "Full Body" : rawValue.capitalized
    }
}

// MARK: - Preview seed

extension AIPlan.WorkoutPlan {
    /// Plan matching the Planner Review design handoff — drives previews and
    /// keeps the screen populated when no pending plan is stashed.
    static let reviewSeed = AIPlan.WorkoutPlan(
        splitType: .bodyPart,
        weeklySessionCount: 4,
        planNotes: nil,
        sessions: [
            .init(
                sessionNumber: 1, focus: "Push — Chest & Triceps",
                suggestedDay: "Mon", estimatedDurationMinutes: 55,
                warmupNotes: nil, cooldownNotes: nil,
                exercises: [
                    .seed("Barbell Bench Press",        .barbell,      [.chest, .shoulders], sets: 4, reps: 6...8,   rest: 120),
                    .seed("Incline Dumbbell Press",     .dumbbells,    [.chest],             sets: 3, reps: 8...10,  rest: 90),
                    .seed("Cable Fly",                  .cableMachine, [.chest],             sets: 3, reps: 12...15, rest: 60),
                    .seed("Overhead Triceps Extension", .dumbbells,    [.triceps],           sets: 3, reps: 10...12, rest: 60),
                    .seed("Triceps Pushdown",           .cableMachine, [.triceps],           sets: 3, reps: 12...15, rest: 45),
                ]
            ),
            .init(
                sessionNumber: 2, focus: "Pull — Back & Biceps",
                suggestedDay: "Wed", estimatedDurationMinutes: 60,
                warmupNotes: nil, cooldownNotes: nil,
                exercises: [
                    .seed("Deadlift",     .barbell,      [.back, .hamstrings], sets: 4, reps: 5...5,   rest: 150),
                    .seed("Pull-Up",      .pullupBar,    [.back, .biceps],     sets: 4, reps: 6...8,   rest: 120),
                    .seed("Barbell Row",  .barbell,      [.back],              sets: 3, reps: 8...10,  rest: 90),
                    .seed("Face Pull",    .cableMachine, [.shoulders],         sets: 3, reps: 12...15, rest: 45),
                    .seed("Barbell Curl", .barbell,      [.biceps],            sets: 3, reps: 10...12, rest: 60),
                ]
            ),
            .init(
                sessionNumber: 3, focus: "Legs — Quads & Glutes",
                suggestedDay: "Fri", estimatedDurationMinutes: 65,
                warmupNotes: nil, cooldownNotes: nil,
                exercises: [
                    .seed("Back Squat",          .barbell,   [.quads, .glutes], sets: 4, reps: 6...6,   rest: 150),
                    .seed("Romanian Deadlift",   .barbell,   [.hamstrings],     sets: 3, reps: 8...10,  rest: 120),
                    .seed("Leg Press",           .fullGym,   [.quads],          sets: 3, reps: 10...12, rest: 90),
                    .seed("Walking Lunge",       .dumbbells, [.glutes, .quads], sets: 3, reps: 10...12, rest: 60),
                    .seed("Standing Calf Raise", .fullGym,   [.calves],         sets: 4, reps: 12...15, rest: 45),
                ]
            ),
            .init(
                sessionNumber: 4, focus: "Upper — Shoulders & Arms",
                suggestedDay: "Sat", estimatedDurationMinutes: 50,
                warmupNotes: nil, cooldownNotes: nil,
                exercises: [
                    .seed("Overhead Press",      .barbell,      [.shoulders], sets: 4, reps: 6...8,   rest: 120),
                    .seed("Lateral Raise",       .dumbbells,    [.shoulders], sets: 3, reps: 12...15, rest: 45),
                    .seed("Incline Curl",        .dumbbells,    [.biceps],    sets: 3, reps: 10...12, rest: 60),
                    .seed("Skull Crusher",       .barbell,      [.triceps],   sets: 3, reps: 10...12, rest: 60),
                    .seed("Cable Lateral Raise", .cableMachine, [.shoulders], sets: 3, reps: 15...20, rest: 45),
                ]
            ),
        ]
    )
}

private extension AIPlan.Exercise {
    static func seed(
        _ name: String,
        _ equipment: AIPlan.Equipment,
        _ primary: [AIPlan.MuscleGroup],
        sets: Int,
        reps: ClosedRange<Int>,
        rest: Int
    ) -> AIPlan.Exercise {
        AIPlan.Exercise(
            name: name,
            equipment: equipment,
            muscles: AIPlan.MuscleGroups(primary: primary, secondary: []),
            sets: sets,
            repsMin: reps.lowerBound,
            repsMax: reps.upperBound,
            restSeconds: rest,
            rpeTarget: nil,
            coachingNotes: nil,
            videoUrl: nil,
            alternatives: []
        )
    }
}
