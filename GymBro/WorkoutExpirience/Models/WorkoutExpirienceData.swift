struct WorkoutExpirienceData {
    var personal = PersonalInformationModel()
    var training = TrainingPreferencesModel()
    var muscles: [MuscleGroupsOptions: Bool] = [:]
    var equipment: [EquipamentOptions: Bool] = [:]
    var injuryDescription: String = ""
    var integrations = Integrations()

	init() {
		MuscleGroupsOptions.allCases.forEach { option in
			muscles[option] = false
		}

		EquipamentOptions.allCases.forEach { option in
			equipment[option] = false
		}
	}
}

struct Integrations {
	var appleHealth: Bool = false
	var googleFit: Bool = false
}
