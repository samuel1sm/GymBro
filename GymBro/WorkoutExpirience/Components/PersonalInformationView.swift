import SwiftUI

struct PersonalInformationView: View {
	@Binding var model: PersonalInformationModel
	var onTapGender: () -> Void

	var body: some View {
		VStack(spacing: 16) {
			HStack(spacing: 16) {
				Image(systemName: "person").frame(width: 16, height: 16)
				Text("Personal Information")
				Spacer()
			}

			DeafaultTextField(
				title: "Name",
				text: $model.name,
				placeholder: "Enter your Name"
			)

			HStack(spacing: 16) {
				DeafaultTextField(
					title: "Age",
					text: $model.age,
					keyboardType: .numberPad,
					placeholder: "ex.: 25"
				)
				DeafaultTextField(
					title: "Gender (Optional)",
					text: $model.gender,
					placeholder: "Select",
					selectableAction: onTapGender
				)
			}

			HStack(spacing: 16) {
				DeafaultTextField(
					title: "Weight (kg)",
					text: $model.weight,
					keyboardType: .numbersAndPunctuation,
					placeholder: "ex.: 25"
				)
				DeafaultTextField(
					title: "Height (cm)",
					text: $model.height,
					keyboardType: .numbersAndPunctuation,
					placeholder: "Select"
				)
			}
		}
	}
}

#Preview {
	PersonalInformationView(
		model: .constant(.init()),
		onTapGender: {}
	)
}
