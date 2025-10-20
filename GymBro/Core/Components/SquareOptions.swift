import SwiftUI

struct SquareOptions<Cases: OptionsProtocol>: View {

	@Binding var selectableOptions: [Cases: Bool]
	private let cases: [Cases] = Array(Cases.allCases)

	var body: some View {
		Grid(alignment: .leadingFirstTextBaseline) {
			ForEach(0...cases.count / 2, id: \.self) { row in
				GridRow {
					ForEach(0..<2) { column in
						let position = 2 * row + column
						if position < cases.count {
							let option = cases[position]
							let status = getOptionStatus(option)

							Button {
								selectableOptions[option] = !status
							} label: {
								HStack {
									CheckBoxView(status: status)
									Text(option.title)
								}
							}
							.buttonStyle(.plain)
							.padding(4)
						}
					}
				}
			}
		}
	}


	private func getOptionStatus(_ option: Cases) -> Bool {
		selectableOptions[option] ?? false
	}
}

#Preview {
	SquareOptions<MuscleGroupsOptions>(selectableOptions: .constant([:]))
}
