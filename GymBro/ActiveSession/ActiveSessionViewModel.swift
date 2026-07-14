import Foundation
import Observation

/// View model for the Active Workout Session screen.
///
/// Owns the persistent session overview (Layer 1) and the per-exercise sheet
/// state (Layer 2 — active set, rest timer, edit mode). The view is a thin
/// projection of this object via `@Bindable`.
@Observable
final class ActiveSessionViewModel {

    // MARK: - Session

    var split: String
    var day: Int
    var exercises: [ActiveSessionExercise]
    var logs: [[LoggedSet]]
    var elapsedSeconds: Int

    var weightUnit: WeightUnit = .kg

    // MARK: - Sheet

    var openIndex: Int? = nil
    var weightInput: String = ""
    var repsInput: String = ""
    var rest: RestState? = nil
    var editIndex: Int? = nil
    var isConfirmingEnd: Bool = false

    // MARK: - Private

    private var savedWeight: String = ""
    private var savedReps: String = ""
    private var clockTask: Task<Void, Never>? = nil

    /// The plan/session this workout logs against — nil when launched from a
    /// flow that isn't wired to a saved plan.
    private let context: ActiveSessionContext?

    /// Wall-clock anchor for the session timer — `elapsedSeconds` is derived
    /// from it on every tick, so time spent suspended still counts.
    private let startedAt: Date

    // MARK: - Init

    /// Real sessions (a context is present) start the clock at zero; the
    /// placeholder session keeps the design's mid-workout elapsed time.
    init(
        state: ActiveSessionState = ActiveSessionState(),
        context: ActiveSessionContext? = nil,
        elapsedSeconds: Int? = nil
    ) {
        let elapsed = elapsedSeconds ?? (context == nil ? 742 : 0)
        self.split = state.split
        self.day = state.day
        self.exercises = state.exercises
        self.logs = state.logs
        self.context = context
        self.elapsedSeconds = elapsed
        self.startedAt = Date.now.addingTimeInterval(-TimeInterval(elapsed))
    }

    // MARK: - Derived

    var doneCount: Int {
        zip(exercises, logs).filter { $0.1.count >= $0.0.sets }.count
    }

    var openExercise: ActiveSessionExercise? {
        guard let i = openIndex, exercises.indices.contains(i) else { return nil }
        return exercises[i]
    }

    var openLogs: [LoggedSet] {
        guard let i = openIndex, logs.indices.contains(i) else { return [] }
        return logs[i]
    }

    var currentMode: LogSheetMode {
        if let rest { return .rest(rest) }
        if let editIndex { return .editing(editIndex) }
        return .active
    }

    // MARK: - Clock

    func startClock() {
        clockTask?.cancel()
        clockTask = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard let self, !Task.isCancelled else { return }
                self.elapsedSeconds = max(0, Int(Date.now.timeIntervalSince(self.startedAt)))
                self.tickRest()
            }
        }
    }

    func stopClock() {
        clockTask?.cancel()
        clockTask = nil
    }

    // MARK: - Actions

    /// Resolves the display unit (saved app settings, else the profile's unit
    /// system) and replaces the placeholder session with the stored session
    /// named by the context, so logged sets reference real `StoredExercise`
    /// ids. The session swap is a no-op once sets have been logged, or when
    /// the context is missing from the library.
    func load(from store: UserStore, settings settingsStore: AppSettingsStore) {
        let user = try? store.loadUser()
        if let saved = settingsStore.load() {
            weightUnit = saved.weightUnit
        } else if let user {
            weightUnit = user.unitSystem == AIPlan.UnitSystem.imperial.rawValue ? .lbs : .kg
        }

        guard
            logs.allSatisfy(\.isEmpty),
            let context,
            let user,
            let plans = try? store.loadSavedPlans(for: user),
            let session = plans.first(where: { $0.id == context.planId })?
                .orderedSessions.first(where: { $0.id == context.sessionId })
        else { return }

        let state = ActiveSessionState(stored: session)
        split = state.split
        day = state.day
        exercises = state.exercises
        logs = state.logs
    }

    func handleBack(pop: () -> Void) {
        if logs.contains(where: { !$0.isEmpty }) {
            isConfirmingEnd = true
        } else {
            pop()
        }
    }

    func endSession(pop: () -> Void, store: UserStore) {
        isConfirmingEnd = false
        openIndex = nil
        saveWorkoutLog(to: store)
        pop()
    }

    /// Persists the finished workout as a completed `StoredWorkoutLog` with
    /// every set logged so far.
    private func saveWorkoutLog(to store: UserStore) {
        guard let context, let user = try? store.loadUser() else { return }

        let sets = zip(exercises, logs).flatMap { exercise, logged in
            logged.enumerated().map { index, set in
                StoredLoggedSet(
                    exerciseId: exercise.id,
                    setIndex: index,
                    weightKg: set.kg,
                    repsCompleted: set.reps
                )
            }
        }

        try? store.saveCompletedWorkout(
            planId: context.planId,
            sessionId: context.sessionId,
            startedAt: startedAt,
            completedAt: .now,
            sets: sets,
            for: user
        )
    }

    func resumeFromConfirm() {
        isConfirmingEnd = false
    }

    func requestConfirmEnd() {
        isConfirmingEnd = true
    }

    func openExerciseSheet(at index: Int) {
        guard exercises.indices.contains(index), logs.indices.contains(index) else { return }
        openIndex = index
        weightInput = lastKg(for: index)
        repsInput = ""
        rest = nil
        editIndex = nil
    }

    func closeSheet() {
        openIndex = nil
        rest = nil
        editIndex = nil
    }

    func endRest() {
        rest = nil
        if let i = openIndex {
            weightInput = lastKg(for: i)
            repsInput = ""
        }
    }

    func logSet() {
        if editIndex != nil {
            exitEdit()
            return
        }
        guard let i = openIndex, exercises.indices.contains(i), logs.indices.contains(i) else { return }
        let exercise = exercises[i]
        let kg = Double(weightInput).map(weightUnit.toKg) ?? exercise.planKg
        let reps = Int(repsInput) ?? exercise.repHi
        logs[i].append(LoggedSet(kg: kg, reps: reps))

        if logs[i].count >= exercise.sets {
            // State C — auto-dismiss after the last set
            Task { @MainActor [weak self] in
                try? await Task.sleep(nanoseconds: 500_000_000)
                guard let self, self.openIndex == i, self.rest == nil else { return }
                self.closeSheet()
            }
        } else {
            // State B — rest
            rest = RestState(total: exercise.restSeconds)
        }
    }

    func tapHistory(_ idx: Int) {
        if editIndex == idx {
            exitEdit()
            return
        }
        if editIndex == nil {
            savedWeight = weightInput
            savedReps = repsInput
        }
        editIndex = idx
        guard let i = openIndex, logs.indices.contains(i), logs[i].indices.contains(idx) else { return }
        let set = logs[i][idx]
        weightInput = SessionFormat.weight(weightUnit.fromKg(set.kg))
        repsInput = String(set.reps)
    }

    // MARK: - Private helpers

    private func tickRest() {
        guard var current = rest else { return }
        current.remaining = max(0, Int(current.endDate.timeIntervalSinceNow.rounded(.up)))
        if current.remaining <= 0 {
            endRest()
        } else {
            rest = current
        }
    }

    private func exitEdit() {
        editIndex = nil
        guard let i = openIndex else { return }
        weightInput = savedWeight.isEmpty ? lastKg(for: i) : savedWeight
        repsInput = savedReps
    }

    private func lastKg(for index: Int) -> String {
        guard exercises.indices.contains(index), logs.indices.contains(index) else { return "" }
        if let last = logs[index].last {
            return SessionFormat.weight(weightUnit.fromKg(last.kg))
        }
        let planKg = exercises[index].planKg
        return planKg > 0 ? SessionFormat.weight(weightUnit.fromKg(planKg)) : ""
    }
}
