import SwiftUI

struct WorkoutExpirienceCustomisation: View {

	@State private var stage: CustomisationStages = .personalInformations
	@State private var textFieldValue: String = ""
	@State private var sexTextFieldValue: String = ""
	@State private var isSexSheetPresented: Bool = false

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

			LoadingBarView(stage: stage, hasStepCounter: true)
				.padding(.bottom, 16)

			VStack(spacing: 16) {
				HStack(spacing: 16) {
					Image(systemName: "person").frame(width: 16, height: 16)
					Text("Personal Information")
					Spacer()
				}

				DeafaultTextField(
					title: "Name",
					text: $textFieldValue,
					placeholder: "Enter your Name"
				)

				HStack(spacing: 16) {
					DeafaultTextField(
						title: "Age",
						text: $textFieldValue,
						keyboardType: .numberPad,
						placeholder: "ex.: 25"
					)
					DeafaultTextField(
						title: "Gender (Optional)",
						text: $sexTextFieldValue,
						placeholder: "Select"
					) {
						isSexSheetPresented = true
					}
				}

				HStack(spacing: 16) {
					DeafaultTextField(
						title: "Weight (kg)",
						text: $textFieldValue,
						keyboardType: .numbersAndPunctuation,
						placeholder: "ex.: 25"
					)
					DeafaultTextField(
						title: "Height (cm)",
						text: $textFieldValue,
						keyboardType: .numbersAndPunctuation,
						placeholder: "Select"
					)
				}
			}.padding(.bottom, 24)

			HStack {
				Button {
					stage = stage.getPreviousStage()
				} label: {
					Text("Back")
				}

				Spacer()

				Button {
					stage = stage.getNextStage()
				} label: {
					Text("Next")
				}
			}
		}
		.padding(16)
		.overlay(
			RoundedRectangle(cornerRadius: 8)
				.stroke(.gray, lineWidth: 1)
		)
		.padding(16)
		.sheet(isPresented: $isSexSheetPresented) {
			VStack(spacing: 16) {
				EmptyView().frame(height: 16)
				Text("Select your gender").font(.title2)
				Spacer()
				ForEach(SexOptions.allCases, id: \.self) { option in
					Button(option.rawValue.capitalized) {
						sexTextFieldValue = option.rawValue.capitalized
						isSexSheetPresented = false
					}
				}
				EmptyView().frame(height: 16)
			}
			.padding(16)
			.presentationDetents([.height(200)])
		}
	}
}

#Preview {
	WorkoutExpirienceCustomisation()
}
