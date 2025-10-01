import SwiftUI

struct WorkoutExpirienceCustomisation: View {

	@State private var stage: CustomisationStages = .personalInformations

	var body: some View {
		VStack(alignment: .leading) {
			HStack(spacing: 16) {
				Image(systemName: "dumbbell.fill").frame(width: 16, height: 16)
				Text("Welcome to GymBro !")
				Spacer()
			}.padding(.leading, 4)
				.padding(.bottom, 4)

			Text("Let's personalize your experience")
				.font(.default)
				.foregroundStyle(.secondary)
				.padding(.bottom, 8)

			LoadingBarView(stage: stage)

			Button {
				stage = stage.getPreviousStage()
			} label: {
				Text("Back")
			}

			Button {
				stage = stage.getNextStage()
			} label: {
				Text("Next")
			}

			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundStyle(.tint)
			Text("Hello, world!")
		}
		.padding(16)
		.overlay(
			RoundedRectangle(cornerRadius: 8)
				.stroke(.gray, lineWidth: 1)
		)
		.padding(16)
	}
}

#Preview {
	WorkoutExpirienceCustomisation()
}
