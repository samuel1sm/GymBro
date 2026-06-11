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

    // MARK: - Init

    init(state: ActiveSessionState = ActiveSessionState(), elapsedSeconds: Int = 742) {
        self.split = state.split
        self.day = state.day
        self.exercises = state.exercises
        self.logs = state.logs
        self.elapsedSeconds = elapsedSeconds
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
        guard let i = openIndex else { return [] }
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
                self.elapsedSeconds += 1
                self.tickRest()
            }
        }
    }

    func stopClock() {
        clockTask?.cancel()
        clockTask = nil
    }

    // MARK: - Actions

    func handleBack(pop: () -> Void) {
        if logs.contains(where: { !$0.isEmpty }) {
            isConfirmingEnd = true
        } else {
            pop()
        }
    }

    func endSession(pop: () -> Void) {
        isConfirmingEnd = false
        openIndex = nil
        pop()
    }

    func resumeFromConfirm() {
        isConfirmingEnd = false
    }

    func requestConfirmEnd() {
        isConfirmingEnd = true
    }

    func openExerciseSheet(at index: Int) {
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
        guard let i = openIndex else { return }
        let exercise = exercises[i]
        let kg = Double(weightInput) ?? exercise.planKg
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
            rest = RestState(remaining: exercise.restSeconds, total: exercise.restSeconds)
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
        guard let i = openIndex else { return }
        let set = logs[i][idx]
        weightInput = SessionFormat.kg(set.kg)
        repsInput = String(set.reps)
    }

    // MARK: - Private helpers

    private func tickRest() {
        guard var current = rest else { return }
        current.remaining -= 1
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
        if let last = logs[index].last {
            return SessionFormat.kg(last.kg)
        }
        return SessionFormat.kg(exercises[index].planKg)
    }
}
