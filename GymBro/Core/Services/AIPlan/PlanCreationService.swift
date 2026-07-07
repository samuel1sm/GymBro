import Foundation

/// `nonisolated` opts the service layer out of the target's default MainActor
/// isolation — plan creation is async backend work, not UI state.
nonisolated protocol PlanCreationService: Sendable {
    func createPlan(from request: AIPlan.PlanRequest) async throws -> AIPlan.WorkoutPlan
}

/// Stand-in until the real AI backend is wired up. Deterministic, but honors
/// the request's split, days, equipment, session length, and fitness level.
nonisolated struct SimulatedPlanCreationService: PlanCreationService {
    func createPlan(from request: AIPlan.PlanRequest) async throws -> AIPlan.WorkoutPlan {
        try await Task.sleep(for: .seconds(2))

        let days = max(1, request.daysPerWeek)
        let split = Self.resolvedSplit(request.preferredSplit, daysPerWeek: days)
        let gear = Gear(request.availableEquipment)
        let rpeOffset = Self.rpeOffset(for: request.fitnessLevel)
        let templates = Self.templates(for: split)
        let exerciseCap = request.sessionDurationMinutes < 45 ? 4 : Int.max

        let sessions = (0..<days).map { index in
            let template = templates[index % templates.count]
            let cycle = index / templates.count
            return AIPlan.WorkoutSession(
                sessionNumber: index + 1,
                focus: cycle == 0 ? template.focus : "\(template.focus) \(cycle + 1)",
                suggestedDay: nil,
                estimatedDurationMinutes: request.sessionDurationMinutes,
                warmupNotes: template.warmup,
                cooldownNotes: template.cooldown,
                exercises: template.exercises.prefix(exerciseCap).map {
                    Self.adjusted($0, gear: gear, rpeOffset: rpeOffset)
                }
            )
        }

        return AIPlan.WorkoutPlan(
            splitType: split,
            weeklySessionCount: sessions.count,
            planNotes: Self.planNotes(for: request, split: split),
            sessions: sessions
        )
    }
}

// MARK: - Request-driven adjustments

private extension SimulatedPlanCreationService {

    /// Equipment the user can actually train with; empty or `.fullGym` means everything.
    nonisolated struct Gear {
        private let available: Set<AIPlan.Equipment>

        init(_ equipment: [AIPlan.Equipment]) {
            let set = Set(equipment)
            available = set.isEmpty || set.contains(.fullGym)
                ? Set(AIPlan.Equipment.allCases)
                : set
        }

        func has(_ equipment: AIPlan.Equipment) -> Bool {
            equipment == .bodyweight || available.contains(equipment)
        }
    }

    static func resolvedSplit(_ preferred: AIPlan.SplitType, daysPerWeek days: Int) -> AIPlan.SplitType {
        guard preferred == .custom else { return preferred }
        switch days {
        case ...3: return .fullBody
        case 4: return .upperLower
        default: return .pushPullLegs
        }
    }

    static func rpeOffset(for level: AIPlan.FitnessLevel) -> Double {
        switch level {
        case .beginner: -1
        case .intermediate: 0
        case .advanced: 0.5
        }
    }

    static func adjusted(_ exercise: AIPlan.Exercise, gear: Gear, rpeOffset: Double) -> AIPlan.Exercise {
        var exercise = swappingForAvailableGear(exercise, gear: gear)
        exercise.rpeTarget = exercise.rpeTarget.map { min(9.5, max(5, $0 + rpeOffset)) }
        return exercise
    }

    /// When the main movement needs missing equipment, promote the first
    /// alternative the user can do and keep the rest as alternatives.
    static func swappingForAvailableGear(_ exercise: AIPlan.Exercise, gear: Gear) -> AIPlan.Exercise {
        guard !gear.has(exercise.equipment),
              let swap = exercise.alternatives.first(where: { gear.has($0.equipment) })
        else { return exercise }

        var result = exercise
        result.name = swap.name
        result.equipment = swap.equipment
        result.muscles = swap.muscles
        result.coachingNotes = swap.coachingNotes ?? exercise.coachingNotes
        result.alternatives = exercise.alternatives.filter { $0 != swap }
        return result
    }

    static func planNotes(for request: AIPlan.PlanRequest, split: AIPlan.SplitType) -> String {
        let splitName: String = switch split {
        case .fullBody: "full-body"
        case .upperLower: "upper/lower"
        case .pushPullLegs: "push/pull/legs"
        case .bodyPart: "body-part"
        case .custom: "custom"
        }

        var notes = "Simulated \(request.daysPerWeek)-day \(splitName) plan for a \(request.fitnessLevel.rawValue) lifter"
        let goals = request.goals.map { $0.rawValue.replacingOccurrences(of: "_", with: " ") }
        if !goals.isEmpty {
            notes += " targeting \(goals.joined(separator: ", "))"
        }
        notes += ". Add reps within the range before adding load, and swap any movement for a listed alternative when equipment or joints ask for it."

        let focus = request.focusMuscleGroups.map { $0.rawValue.replacingOccurrences(of: "_", with: " ") }
        if !focus.isEmpty {
            notes += " Prioritize \(focus.joined(separator: ", ")) work when short on time."
        }
        if let injuries = request.injuriesAndLimitations, !injuries.isEmpty {
            notes += " Noted limitations: \(injuries)."
        }
        return notes
    }
}

// MARK: - Session templates

private extension SimulatedPlanCreationService {

    nonisolated struct SessionTemplate {
        var focus: String
        var warmup: String
        var cooldown: String
        var exercises: [AIPlan.Exercise]
    }

    static func templates(for split: AIPlan.SplitType) -> [SessionTemplate] {
        switch split {
        case .pushPullLegs: [pushDay, pullDay, legDay]
        case .upperLower: [upperDay, lowerDay]
        case .bodyPart: [chestDay, backDay, legDay, shouldersDay, armsAndCoreDay]
        case .fullBody, .custom: [fullBodyA, fullBodyB]
        }
    }

    static let pushDay = SessionTemplate(
        focus: "Push",
        warmup: "5 min incline walk, arm circles, band pull-aparts, then 2 light ramp-up sets on the first press",
        cooldown: "Doorway pec stretch and overhead triceps stretch, 30s each side",
        exercises: [benchPress, overheadPress, inclinePress, lateralRaise, tricepsPushdown]
    )

    static let pullDay = SessionTemplate(
        focus: "Pull",
        warmup: "5 min row or jumping jacks, scap pull-ups, light band rows",
        cooldown: "Lat and biceps stretch, 30s each side, slow neck rolls",
        exercises: [deadlift, pullUp, seatedRow, facePull, bicepsCurl]
    )

    static let legDay = SessionTemplate(
        focus: "Legs",
        warmup: "5 min bike, leg swings, hip openers, bodyweight squats",
        cooldown: "Quad, hamstring, and calf stretch, 45s each",
        exercises: [backSquat, romanianDeadlift, bulgarianSplitSquat, calfRaise, hangingKneeRaise]
    )

    static let upperDay = SessionTemplate(
        focus: "Upper Body",
        warmup: "5 min light cardio, arm circles, band pull-aparts, ramp-up sets on the first press",
        cooldown: "Pec, lat, and triceps stretch, 30s each side",
        exercises: [benchPress, barbellRow, overheadPress, pullUp, bicepsCurl, tricepsPushdown]
    )

    static let lowerDay = SessionTemplate(
        focus: "Lower Body",
        warmup: "5 min bike, leg swings, hip openers, bodyweight squats",
        cooldown: "Quad, hamstring, glute, and calf stretch, 45s each",
        exercises: [backSquat, romanianDeadlift, walkingLunge, calfRaise, plank]
    )

    static let fullBodyA = SessionTemplate(
        focus: "Full Body A",
        warmup: "5 min light cardio, dynamic stretches, one ramp-up set for the first lift",
        cooldown: "5 min static stretching, longest on whatever worked hardest",
        exercises: [backSquat, benchPress, pullUp, lateralRaise, plank]
    )

    static let fullBodyB = SessionTemplate(
        focus: "Full Body B",
        warmup: "5 min light cardio, dynamic stretches, one ramp-up set for the first lift",
        cooldown: "5 min static stretching, longest on whatever worked hardest",
        exercises: [romanianDeadlift, overheadPress, seatedRow, walkingLunge, hangingKneeRaise]
    )

    static let chestDay = SessionTemplate(
        focus: "Chest",
        warmup: "5 min incline walk, arm circles, 2 light ramp-up sets on the bench",
        cooldown: "Doorway pec stretch, 30s each side",
        exercises: [benchPress, inclinePress, cableFly, chestDip]
    )

    static let backDay = SessionTemplate(
        focus: "Back",
        warmup: "5 min row, scap pull-ups, light band rows",
        cooldown: "Lat stretch on a rack, 30s each side",
        exercises: [deadlift, pullUp, seatedRow, facePull]
    )

    static let shouldersDay = SessionTemplate(
        focus: "Shoulders",
        warmup: "Arm circles, band pull-aparts, light presses",
        cooldown: "Cross-body and overhead shoulder stretch, 30s each side",
        exercises: [overheadPress, lateralRaise, rearDeltFly, facePull]
    )

    static let armsAndCoreDay = SessionTemplate(
        focus: "Arms & Core",
        warmup: "5 min light cardio, wrist circles, light curls and pressdowns",
        cooldown: "Biceps and triceps stretch, 30s each side",
        exercises: [bicepsCurl, tricepsPushdown, hangingKneeRaise, plank]
    )
}

// MARK: - Exercise catalog

private extension SimulatedPlanCreationService {

    static let benchPress = exercise(
        "Barbell Bench Press", .barbell,
        primary: [.chest], secondary: [.triceps, .shoulders],
        sets: 4, reps: 6...10, rest: 150, rpe: 7.5,
        notes: "Feet planted, slight arch, bar to mid-chest — press to full lockout.",
        alternatives: [
            alternative("Dumbbell Bench Press", .dumbbells, primary: [.chest], secondary: [.triceps, .shoulders]),
            alternative("Push-Up", .bodyweight, primary: [.chest], secondary: [.triceps, .shoulders])
        ]
    )

    static let inclinePress = exercise(
        "Incline Dumbbell Press", .dumbbells,
        primary: [.chest], secondary: [.shoulders, .triceps],
        sets: 3, reps: 8...12, rest: 90, rpe: 7.5,
        alternatives: [
            alternative("Feet-Elevated Push-Up", .bodyweight, primary: [.chest], secondary: [.shoulders, .triceps])
        ]
    )

    static let cableFly = exercise(
        "Cable Fly", .cableMachine,
        primary: [.chest],
        sets: 3, reps: 12...15, rest: 60, rpe: 8,
        notes: "Soft elbows, squeeze at the midline, control the stretch.",
        alternatives: [
            alternative("Dumbbell Fly", .dumbbells, primary: [.chest]),
            alternative("Band Fly", .resistanceBands, primary: [.chest])
        ]
    )

    static let chestDip = exercise(
        "Chest Dip", .bodyweight,
        primary: [.chest], secondary: [.triceps, .shoulders],
        sets: 3, reps: 8...12, rest: 90, rpe: 8,
        notes: "Lean forward slightly, elbows track back, stop before the shoulder complains.",
        alternatives: [
            alternative("Push-Up", .bodyweight, primary: [.chest], secondary: [.triceps])
        ]
    )

    static let overheadPress = exercise(
        "Overhead Press", .barbell,
        primary: [.shoulders], secondary: [.triceps, .abs],
        sets: 3, reps: 6...10, rest: 120, rpe: 7.5,
        notes: "Squeeze glutes, ribs down, press to a full lockout over the ears.",
        alternatives: [
            alternative("Seated Dumbbell Shoulder Press", .dumbbells, primary: [.shoulders], secondary: [.triceps]),
            alternative("Pike Push-Up", .bodyweight, primary: [.shoulders], secondary: [.triceps])
        ]
    )

    static let lateralRaise = exercise(
        "Lateral Raise", .dumbbells,
        primary: [.shoulders],
        sets: 3, reps: 12...20, rest: 60, rpe: 8,
        notes: "Lead with the elbows; stop just above shoulder height.",
        alternatives: [
            alternative("Band Lateral Raise", .resistanceBands, primary: [.shoulders])
        ]
    )

    static let rearDeltFly = exercise(
        "Rear Delt Fly", .dumbbells,
        primary: [.shoulders], secondary: [.back],
        sets: 3, reps: 12...15, rest: 60, rpe: 8,
        alternatives: [
            alternative("Band Pull-Apart", .resistanceBands, primary: [.shoulders], secondary: [.back])
        ]
    )

    static let deadlift = exercise(
        "Conventional Deadlift", .barbell,
        primary: [.back, .glutes], secondary: [.hamstrings, .forearms],
        sets: 3, reps: 4...6, rest: 180, rpe: 7.5,
        notes: "Wedge in, pull the slack out, push the floor away. Leave a rep in the tank.",
        alternatives: [
            alternative("Kettlebell Deadlift", .kettlebell, primary: [.back, .glutes], secondary: [.hamstrings]),
            alternative("Dumbbell Romanian Deadlift", .dumbbells, primary: [.hamstrings, .glutes], secondary: [.back])
        ]
    )

    static let pullUp = exercise(
        "Pull-Up", .pullupBar,
        primary: [.back, .biceps], secondary: [.forearms],
        sets: 3, reps: 6...10, rest: 120, rpe: 8,
        notes: "Full hang to chin over the bar; add load once the top of the range feels easy.",
        alternatives: [
            alternative("Lat Pulldown", .cableMachine, primary: [.back, .biceps]),
            alternative("One-Arm Dumbbell Row", .dumbbells, primary: [.back], secondary: [.biceps])
        ]
    )

    static let barbellRow = exercise(
        "Bent-Over Barbell Row", .barbell,
        primary: [.back], secondary: [.biceps, .forearms],
        sets: 3, reps: 8...10, rest: 120, rpe: 7.5,
        notes: "Hinge to about 45°, pull to the lower ribs, no torso heave.",
        alternatives: [
            alternative("One-Arm Dumbbell Row", .dumbbells, primary: [.back], secondary: [.biceps]),
            alternative("Band Row", .resistanceBands, primary: [.back], secondary: [.biceps])
        ]
    )

    static let seatedRow = exercise(
        "Seated Cable Row", .cableMachine,
        primary: [.back], secondary: [.biceps],
        sets: 3, reps: 10...12, rest: 90, rpe: 7.5,
        alternatives: [
            alternative("Bent-Over Dumbbell Row", .dumbbells, primary: [.back], secondary: [.biceps]),
            alternative("Band Row", .resistanceBands, primary: [.back], secondary: [.biceps])
        ]
    )

    static let facePull = exercise(
        "Face Pull", .cableMachine,
        primary: [.shoulders], secondary: [.back],
        sets: 3, reps: 12...15, rest: 60, rpe: 7,
        notes: "Pull to the bridge of the nose, thumbs pointing back.",
        alternatives: [
            alternative("Band Pull-Apart", .resistanceBands, primary: [.shoulders], secondary: [.back])
        ]
    )

    static let bicepsCurl = exercise(
        "Dumbbell Curl", .dumbbells,
        primary: [.biceps], secondary: [.forearms],
        sets: 3, reps: 10...15, rest: 60, rpe: 8,
        alternatives: [
            alternative("Band Curl", .resistanceBands, primary: [.biceps], secondary: [.forearms])
        ]
    )

    static let tricepsPushdown = exercise(
        "Triceps Pushdown", .cableMachine,
        primary: [.triceps],
        sets: 3, reps: 10...15, rest: 60, rpe: 8,
        alternatives: [
            alternative("Overhead Dumbbell Extension", .dumbbells, primary: [.triceps]),
            alternative("Diamond Push-Up", .bodyweight, primary: [.triceps], secondary: [.chest])
        ]
    )

    static let backSquat = exercise(
        "Barbell Back Squat", .barbell,
        primary: [.quads, .glutes], secondary: [.hamstrings, .abs],
        sets: 4, reps: 5...8, rest: 180, rpe: 7.5,
        notes: "Brace before you descend; only go as deep as you can control.",
        alternatives: [
            alternative("Goblet Squat", .dumbbells, primary: [.quads, .glutes], secondary: [.abs]),
            alternative("Tempo Bodyweight Squat", .bodyweight, primary: [.quads, .glutes],
                        notes: "3s down, 1s pause at the bottom.")
        ]
    )

    static let romanianDeadlift = exercise(
        "Romanian Deadlift", .barbell,
        primary: [.hamstrings, .glutes], secondary: [.back],
        sets: 3, reps: 8...12, rest: 120, rpe: 7.5,
        notes: "Push the hips back until the hamstrings load; bar stays close.",
        alternatives: [
            alternative("Dumbbell Romanian Deadlift", .dumbbells, primary: [.hamstrings, .glutes]),
            alternative("Single-Leg Hip Hinge", .bodyweight, primary: [.hamstrings, .glutes])
        ]
    )

    static let bulgarianSplitSquat = exercise(
        "Bulgarian Split Squat", .dumbbells,
        primary: [.quads, .glutes],
        sets: 3, reps: 8...12, rest: 90, rpe: 8,
        notes: "Reps are per leg. Front shin vertical, torso tall.",
        alternatives: [
            alternative("Reverse Lunge", .bodyweight, primary: [.quads, .glutes])
        ]
    )

    static let walkingLunge = exercise(
        "Dumbbell Walking Lunge", .dumbbells,
        primary: [.quads, .glutes], secondary: [.hamstrings],
        sets: 3, reps: 10...12, rest: 90, rpe: 8,
        notes: "Reps are per leg.",
        alternatives: [
            alternative("Bodyweight Walking Lunge", .bodyweight, primary: [.quads, .glutes])
        ]
    )

    static let calfRaise = exercise(
        "Standing Calf Raise", .bodyweight,
        primary: [.calves],
        sets: 4, reps: 12...20, rest: 45, rpe: 8,
        notes: "Pause at the stretch, drive to full tiptoe."
    )

    static let hangingKneeRaise = exercise(
        "Hanging Knee Raise", .pullupBar,
        primary: [.abs], secondary: [.forearms],
        sets: 3, reps: 10...15, rest: 60, rpe: 8,
        alternatives: [
            alternative("Dead Bug", .bodyweight, primary: [.abs])
        ]
    )

    static let plank = exercise(
        "Plank", .bodyweight,
        primary: [.abs],
        sets: 3, reps: 30...60, rest: 45, rpe: nil,
        notes: "Reps are seconds — hold tall, don't let the hips sag."
    )

    static func exercise(
        _ name: String,
        _ equipment: AIPlan.Equipment,
        primary: [AIPlan.MuscleGroup],
        secondary: [AIPlan.MuscleGroup] = [],
        sets: Int,
        reps: ClosedRange<Int>,
        rest: Int,
        rpe: Double?,
        notes: String? = nil,
        alternatives: [AIPlan.AlternativeExercise] = []
    ) -> AIPlan.Exercise {
        AIPlan.Exercise(
            name: name,
            equipment: equipment,
            muscles: AIPlan.MuscleGroups(primary: primary, secondary: secondary),
            sets: sets,
            repsMin: reps.lowerBound,
            repsMax: reps.upperBound,
            restSeconds: rest,
            rpeTarget: rpe,
            coachingNotes: notes,
            videoUrl: nil,
            alternatives: alternatives
        )
    }

    static func alternative(
        _ name: String,
        _ equipment: AIPlan.Equipment,
        primary: [AIPlan.MuscleGroup],
        secondary: [AIPlan.MuscleGroup] = [],
        notes: String? = nil
    ) -> AIPlan.AlternativeExercise {
        AIPlan.AlternativeExercise(
            name: name,
            equipment: equipment,
            muscles: AIPlan.MuscleGroups(primary: primary, secondary: secondary),
            coachingNotes: notes,
            videoUrl: nil
        )
    }
}
