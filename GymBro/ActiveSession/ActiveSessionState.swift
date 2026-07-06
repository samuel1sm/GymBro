import Foundation

// MARK: - Models

struct ActiveSessionExercise: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var subtitle: String
    var muscles: [String]
    var sets: Int
    var repLo: Int
    var repHi: Int
    var planKg: Double
    var restSeconds: Int
}

struct LoggedSet: Hashable {
    var kg: Double
    var reps: Int
}

/// Rest countdown anchored to a wall-clock end date, so time spent suspended
/// (phone locked between sets) still counts. `remaining` is a display snapshot
/// refreshed from `endDate` on every clock tick.
struct RestState: Hashable {
    var endDate: Date
    var total: Int
    var remaining: Int

    init(total: Int, now: Date = .now) {
        self.endDate = now.addingTimeInterval(TimeInterval(total))
        self.total = total
        self.remaining = total
    }
}

// MARK: - State

/// Active workout session — Push day pushed in from the planner.
struct ActiveSessionState {
    var split: String = "PUSH"
    var day: Int = 1
    var exercises: [ActiveSessionExercise] = ActiveSessionState.seed
    var logs: [[LoggedSet]]

    init() {
        self.logs = Array(repeating: [], count: ActiveSessionState.seed.count)
    }

    static let seed: [ActiveSessionExercise] = [
        .init(name: "Barbell Bench Press",       subtitle: "Barbell · Flat bench",   muscles: ["Chest", "Triceps", "Front Delts"], sets: 4, repLo: 8,  repHi: 10, planKg: 80, restSeconds: 120),
        .init(name: "Incline Dumbbell Press",    subtitle: "Dumbbell · 30° incline", muscles: ["Upper Chest", "Front Delts"],      sets: 4, repLo: 8,  repHi: 10, planKg: 32, restSeconds: 90),
        .init(name: "Cable Fly",                 subtitle: "Cable · High-to-low",    muscles: ["Chest"],                           sets: 3, repLo: 12, repHi: 15, planKg: 18, restSeconds: 75),
        .init(name: "Overhead Triceps Ext.",     subtitle: "Cable · Rope",           muscles: ["Triceps"],                         sets: 3, repLo: 10, repHi: 12, planKg: 25, restSeconds: 60),
        .init(name: "Triceps Pushdown",          subtitle: "Cable · Straight bar",   muscles: ["Triceps"],                         sets: 3, repLo: 12, repHi: 15, planKg: 30, restSeconds: 60),
        .init(name: "Cable Lateral Raise",       subtitle: "Cable · Single-arm",     muscles: ["Side Delts"],                      sets: 3, repLo: 15, repHi: 20, planKg: 9,  restSeconds: 45),
    ]
}

// MARK: - Helpers

enum SessionFormat {
    /// "12:07" / "0:08" style mm:ss formatter, never negative.
    static func mmss(_ seconds: Int) -> String {
        let s = max(0, seconds)
        return "\(s / 60):\(String(format: "%02d", s % 60))"
    }

    /// Display a kg value the way the design does — integer when whole, one
    /// decimal otherwise (matches JS `String(82.5)` / `String(80)`).
    static func kg(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        }
        return String(value)
    }
}
