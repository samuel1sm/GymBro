import Foundation
import Observation

/// Thrown by `persistPlan` when there's no saved user and no stashed request
/// to create one from — the plan would have nowhere to attach.
struct MissingUserForPlanError: Error {}

/// Holds the generated plan (and the request that produced it) between plan
/// generation and account creation. Backed by `UserDefaults` so the plan
/// survives the app being closed before the user signs up or logs in.
@Observable
final class PendingPlanStore {

    private struct Pending: Codable {
        var request: AIPlan.PlanRequest
        var plan: AIPlan.WorkoutPlan
    }

    private static let defaultsKey = "pendingPlan"

    @ObservationIgnored private let defaults: UserDefaults

    private(set) var request: AIPlan.PlanRequest?
    private(set) var plan: AIPlan.WorkoutPlan?

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: Self.defaultsKey),
           let pending = try? JSONDecoder().decode(Pending.self, from: data) {
            request = pending.request
            plan = pending.plan.fillingSuggestedDays(from: pending.request)
        }
    }

    var hasPendingPlan: Bool { request != nil && plan != nil }

    func stash(request: AIPlan.PlanRequest, plan: AIPlan.WorkoutPlan) {
        let plan = plan.fillingSuggestedDays(from: request)
        self.request = request
        self.plan = plan
        if let data = try? JSONEncoder().encode(Pending(request: request, plan: plan)) {
            defaults.set(data, forKey: Self.defaultsKey)
        }
    }

    func clear() {
        request = nil
        plan = nil
        defaults.removeObject(forKey: Self.defaultsKey)
    }

    /// Saves just the user profile from the stashed request, keeping the plan
    /// stashed for Planner Review. No-op when nothing is pending.
    func persistUser(to store: UserStore) throws {
        guard let request else { return }
        try store.saveUser(request)
    }

    /// Persists the given plan — the stashed plan with any review edits
    /// applied — for the saved user and clears the stash. Falls back to
    /// creating the user from the stashed request if sign-up didn't save one
    /// (e.g. the user signed in instead). Throws `MissingUserForPlanError`
    /// when neither exists, so callers never mistake a dropped plan for a save.
    func persistPlan(_ plan: AIPlan.WorkoutPlan, to store: UserStore) throws {
        let user: StoredUser
        if let existing = try store.loadUser() {
            user = existing
        } else if let request {
            user = try store.saveUser(request)
        } else {
            throw MissingUserForPlanError()
        }
        try store.savePlan(plan, for: user, name: nil)
        clear()
    }
}
