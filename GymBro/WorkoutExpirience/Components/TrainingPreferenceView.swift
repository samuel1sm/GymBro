import SwiftUI

struct TrainingPreferenceView: View {
	
	@Binding var model: TrainingPreferencesModel
	let onOptionSelected: (WorkoutOptionsStates) -> ()

	var body: some View {
		VStack(spacing: 16) {
			HStack(spacing: 16) {
				Image(systemName: "target").frame(width: 16, height: 16)
				Text("Training Preferences")
				Spacer()
			}

			DefaultSelectableField<TrainingDaysPerWeekOptions>(
				title: "Training days per week",
				option: $model.trainingOption,
				placeholder: "Ex.: 2 Days",
				selectableAction: { onOptionSelected(.trainingDaysPerWeek) }
			)

			DefaultSelectableField<SplitOptions>(
				title: "Split Type",
				option: $model.splitOption,
				placeholder: "Ex.: AB Split (2 Workouts)",
				selectableAction: { onOptionSelected(.split) }
			)

			DefaultSelectableField<ExpirienceOptions>(
				title: "Expirience Level",
				option: $model.expirienceOption,
				placeholder: "",
				selectableAction: { onOptionSelected(.expirience) }
			)
		}
	}
}

#Preview {
	TrainingPreferenceView(model: .constant(.init())) { _ in }
}
