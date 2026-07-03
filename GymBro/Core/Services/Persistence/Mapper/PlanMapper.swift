import Foundation

enum PlanMapper {

    // MARK: - Plan: AIPlan -> Stored

    /// Builds a `StoredPlan` graph from a decoded plan. `request` is unused for
    /// now — kept so a saved plan can later be correlated to its generating request.
    static func toStored(
        plan: AIPlan.WorkoutPlan,
        request: AIPlan.PlanRequest?,
        name: String?
    ) -> StoredPlan {
        let stored = StoredPlan(
            name: name,
            splitType: plan.splitType.rawValue,
            weeklySessionCount: plan.weeklySessionCount,
            planNotes: plan.planNotes
        )

        stored.sessions = plan.sessions.map { session in
            let storedSession = StoredSession(
                sessionNumber: session.sessionNumber,
                focus: session.focus,
                suggestedDay: session.suggestedDay,
                estimatedDurationMinutes: session.estimatedDurationMinutes,
                warmupNotes: session.warmupNotes,
                cooldownNotes: session.cooldownNotes
            )

            storedSession.exercises = session.exercises.enumerated().map { index, exercise in
                let storedExercise = StoredExercise(
                    name: exercise.name,
                    equipment: exercise.equipment.rawValue,
                    orderIndex: index,
                    sets: exercise.sets,
                    repsMin: exercise.repsMin,
                    repsMax: exercise.repsMax,
                    restSeconds: exercise.restSeconds,
                    rpeTarget: exercise.rpeTarget,
                    coachingNotes: exercise.coachingNotes,
                    videoUrl: exercise.videoUrl,
                    primaryMuscles: exercise.muscles.primary.map(\.rawValue),
                    secondaryMuscles: exercise.muscles.secondary.map(\.rawValue)
                )

                storedExercise.alternatives = exercise.alternatives.enumerated().map { altIndex, alt in
                    StoredAlternative(
                        name: alt.name,
                        equipment: alt.equipment.rawValue,
                        orderIndex: altIndex,
                        coachingNotes: alt.coachingNotes,
                        videoUrl: alt.videoUrl,
                        primaryMuscles: alt.muscles.primary.map(\.rawValue),
                        secondaryMuscles: alt.muscles.secondary.map(\.rawValue)
                    )
                }

                return storedExercise
            }

            return storedSession
        }

        return stored
    }

    // MARK: - Plan: Stored -> AIPlan

    static func toAIPlan(stored: StoredPlan) -> AIPlan.WorkoutPlan {
        AIPlan.WorkoutPlan(
            splitType: AIPlan.SplitType(rawValue: stored.splitType) ?? .custom,
            weeklySessionCount: stored.weeklySessionCount,
            planNotes: stored.planNotes,
            sessions: stored.orderedSessions.map { session in
                AIPlan.WorkoutSession(
                    sessionNumber: session.sessionNumber,
                    focus: session.focus,
                    suggestedDay: session.suggestedDay,
                    estimatedDurationMinutes: session.estimatedDurationMinutes,
                    warmupNotes: session.warmupNotes,
                    cooldownNotes: session.cooldownNotes,
                    exercises: session.orderedExercises.map { exercise in
                        AIPlan.Exercise(
                            name: exercise.name,
                            equipment: AIPlan.Equipment(rawValue: exercise.equipment) ?? .bodyweight,
                            muscles: muscleGroups(
                                primary: exercise.primaryMuscles,
                                secondary: exercise.secondaryMuscles
                            ),
                            sets: exercise.sets,
                            repsMin: exercise.repsMin,
                            repsMax: exercise.repsMax,
                            restSeconds: exercise.restSeconds,
                            rpeTarget: exercise.rpeTarget,
                            coachingNotes: exercise.coachingNotes,
                            videoUrl: exercise.videoUrl,
                            alternatives: exercise.orderedAlternatives.map { alt in
                                AIPlan.AlternativeExercise(
                                    name: alt.name,
                                    equipment: AIPlan.Equipment(rawValue: alt.equipment) ?? .bodyweight,
                                    muscles: muscleGroups(
                                        primary: alt.primaryMuscles,
                                        secondary: alt.secondaryMuscles
                                    ),
                                    coachingNotes: alt.coachingNotes,
                                    videoUrl: alt.videoUrl
                                )
                            }
                        )
                    }
                )
            }
        )
    }

    // MARK: - User: AIPlan -> Stored

    static func makeUser(from request: AIPlan.PlanRequest) -> StoredUser {
        StoredUser(
            name: request.name,
            birthDate: request.birthDate,
            sex: request.sex.rawValue,
            weightKg: request.weightKg,
            heightCm: request.heightCm,
            unitSystem: request.unitSystem.rawValue,
            fitnessLevel: request.fitnessLevel.rawValue,
            goals: request.goals.map(\.rawValue),
            focusMuscleGroups: request.focusMuscleGroups.map(\.rawValue),
            availableEquipment: request.availableEquipment.map(\.rawValue),
            injuriesAndLimitations: request.injuriesAndLimitations,
            daysPerWeek: request.daysPerWeek,
            sessionDurationMinutes: request.sessionDurationMinutes,
            preferredTrainingDays: request.preferredTrainingDays.map(\.rawValue),
            preferredSplit: request.preferredSplit.rawValue
        )
    }

    /// Updates an existing profile in place, bumping `updatedAt`.
    static func apply(_ request: AIPlan.PlanRequest, to user: StoredUser) {
        user.name = request.name
        user.birthDate = request.birthDate
        user.sex = request.sex.rawValue
        user.weightKg = request.weightKg
        user.heightCm = request.heightCm
        user.unitSystem = request.unitSystem.rawValue
        user.fitnessLevel = request.fitnessLevel.rawValue
        user.goals = request.goals.map(\.rawValue)
        user.focusMuscleGroups = request.focusMuscleGroups.map(\.rawValue)
        user.availableEquipment = request.availableEquipment.map(\.rawValue)
        user.injuriesAndLimitations = request.injuriesAndLimitations
        user.daysPerWeek = request.daysPerWeek
        user.sessionDurationMinutes = request.sessionDurationMinutes
        user.preferredTrainingDays = request.preferredTrainingDays.map(\.rawValue)
        user.preferredSplit = request.preferredSplit.rawValue
        user.updatedAt = .now
    }

    // MARK: - User: Stored -> AIPlan

    /// Rebuilds a `PlanRequest` from a stored profile (e.g. to regenerate a plan).
    static func toRequest(_ user: StoredUser) -> AIPlan.PlanRequest {
        AIPlan.PlanRequest(
            name: user.name,
            birthDate: user.birthDate,
            sex: AIPlan.BiologicalSex(rawValue: user.sex) ?? .unspecified,
            weightKg: user.weightKg,
            heightCm: user.heightCm,
            unitSystem: AIPlan.UnitSystem(rawValue: user.unitSystem) ?? .metric,
            fitnessLevel: AIPlan.FitnessLevel(rawValue: user.fitnessLevel) ?? .beginner,
            goals: user.goals.compactMap(AIPlan.FitnessGoal.init(rawValue:)),
            focusMuscleGroups: user.focusMuscleGroups.compactMap(AIPlan.MuscleGroup.init(rawValue:)),
            availableEquipment: user.availableEquipment.compactMap(AIPlan.Equipment.init(rawValue:)),
            injuriesAndLimitations: user.injuriesAndLimitations,
            daysPerWeek: user.daysPerWeek,
            sessionDurationMinutes: user.sessionDurationMinutes,
            preferredTrainingDays: user.preferredTrainingDays.compactMap(AIPlan.Weekday.init(rawValue:)),
            preferredSplit: AIPlan.SplitType(rawValue: user.preferredSplit) ?? .custom
        )
    }

    // MARK: - Helpers

    private static func muscleGroups(primary: [String], secondary: [String]) -> AIPlan.MuscleGroups {
        AIPlan.MuscleGroups(
            primary: primary.compactMap(AIPlan.MuscleGroup.init(rawValue:)),
            secondary: secondary.compactMap(AIPlan.MuscleGroup.init(rawValue:))
        )
    }
}
