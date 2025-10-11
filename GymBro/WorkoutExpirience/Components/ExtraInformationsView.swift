import SwiftUI

struct ExtraInformationsView: View {

	@Binding var selectableOptions: [MuscleGroupsOptions: Bool]
	@Binding var equipamentOptions: [EquipamentOptions: Bool]

	var body: some View {
		VStack(alignment: .leading, spacing: 2) {
			Text("Priorities Muscles Group")
				.font(.subheadline)
				.bold()
			Text("Select the muscle groups you want to focous on")
				.font(.subheadline)
				.foregroundStyle(Color(.systemGray))
				.padding(.bottom, 8)

			SquareOptions<MuscleGroupsOptions>(selectableOptions: $selectableOptions)
				.padding(.bottom, 16)

			Text("Available Equipament")
				.font(.subheadline)
				.bold()
			Text("Select all equipament you have access to")
				.font(.subheadline)
				.foregroundStyle(Color(.systemGray))
				.padding(.bottom, 8)

			SquareOptions<EquipamentOptions>(selectableOptions: $equipamentOptions)
				.padding(.bottom, 16)
		}
	}
}

#Preview {
	ExtraInformationsView(
		selectableOptions: .constant([:]),
		equipamentOptions: .constant([:])
	)
}
