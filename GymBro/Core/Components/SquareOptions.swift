import SwiftUI

struct SquareOptions<Cases: OptionsProtocol>: View {

	@Binding private var selectableOptions: [Cases: Bool]
	private let cases: [Cases]

	init(selectableOptions: Binding<[Cases : Bool]>) {
		self._selectableOptions = selectableOptions
		cases = Array(Cases.allCases)
		cases.forEach { option in
			self.selectableOptions[option] = self.selectableOptions[option] ?? false
		}
	}

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
									Image(systemName: status ? "checkmark.square.fill" : "square")
										.foregroundColor(status ? .black : .secondary)
									Text(option.title).bold()
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
