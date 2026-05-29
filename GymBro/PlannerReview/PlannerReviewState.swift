import Foundation

// MARK: - Models

struct PlannerExercise: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var muscles: String
    var sets: Int
    var reps: Int
    var restSeconds: Int
}

struct PlannerTrainingSlot: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String          // "Training 1"
    var date: String          // "Mon"
    var focus: String         // "Push — Chest & Triceps"
    var estimatedMinutes: Int
    var exercises: [PlannerExercise]
}

// MARK: - State

/// Reviewable weekly plan. Matches the seed data shipped in the Planner Review
/// design (4 training slots, soft suggested dates).
struct PlannerReviewState {
    var slots: [PlannerTrainingSlot] = PlannerReviewState.seed

    static let seed: [PlannerTrainingSlot] = [
        .init(
            name: "Training 1", date: "Mon",
            focus: "Push — Chest & Triceps", estimatedMinutes: 55,
            exercises: [
                .init(name: "Barbell Bench Press",       muscles: "Chest · Front Delts", sets: 4, reps: 8,  restSeconds: 120),
                .init(name: "Incline Dumbbell Press",    muscles: "Upper Chest",         sets: 3, reps: 10, restSeconds: 90),
                .init(name: "Cable Fly",                 muscles: "Chest",               sets: 3, reps: 12, restSeconds: 60),
                .init(name: "Overhead Triceps Extension",muscles: "Triceps",             sets: 3, reps: 12, restSeconds: 60),
                .init(name: "Triceps Pushdown",          muscles: "Triceps",             sets: 3, reps: 15, restSeconds: 45),
            ]
        ),
        .init(
            name: "Training 2", date: "Wed",
            focus: "Pull — Back & Biceps", estimatedMinutes: 60,
            exercises: [
                .init(name: "Deadlift",      muscles: "Back · Hamstrings", sets: 4, reps: 5,  restSeconds: 150),
                .init(name: "Pull-Up",       muscles: "Lats · Biceps",     sets: 4, reps: 8,  restSeconds: 120),
                .init(name: "Barbell Row",   muscles: "Mid Back",          sets: 3, reps: 10, restSeconds: 90),
                .init(name: "Face Pull",     muscles: "Rear Delts",        sets: 3, reps: 15, restSeconds: 45),
                .init(name: "Barbell Curl",  muscles: "Biceps",            sets: 3, reps: 12, restSeconds: 60),
            ]
        ),
        .init(
            name: "Training 3", date: "Fri",
            focus: "Legs — Quads & Glutes", estimatedMinutes: 65,
            exercises: [
                .init(name: "Back Squat",          muscles: "Quads · Glutes", sets: 4, reps: 6,  restSeconds: 150),
                .init(name: "Romanian Deadlift",   muscles: "Hamstrings",     sets: 3, reps: 10, restSeconds: 120),
                .init(name: "Leg Press",           muscles: "Quads",          sets: 3, reps: 12, restSeconds: 90),
                .init(name: "Walking Lunge",       muscles: "Glutes · Quads", sets: 3, reps: 12, restSeconds: 60),
                .init(name: "Standing Calf Raise", muscles: "Calves",         sets: 4, reps: 15, restSeconds: 45),
            ]
        ),
        .init(
            name: "Training 4", date: "Sat",
            focus: "Upper — Shoulders & Arms", estimatedMinutes: 50,
            exercises: [
                .init(name: "Overhead Press",      muscles: "Shoulders",  sets: 4, reps: 8,  restSeconds: 120),
                .init(name: "Lateral Raise",       muscles: "Side Delts", sets: 3, reps: 15, restSeconds: 45),
                .init(name: "Incline Curl",        muscles: "Biceps",     sets: 3, reps: 12, restSeconds: 60),
                .init(name: "Skull Crusher",       muscles: "Triceps",    sets: 3, reps: 12, restSeconds: 60),
                .init(name: "Cable Lateral Raise", muscles: "Side Delts", sets: 3, reps: 20, restSeconds: 45),
            ]
        ),
    ]
}
