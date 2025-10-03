import SwiftUI

struct DefaultSelectableField<Option: OptionsProtocol>: View {
	let title: String
	@Binding var option: Option?
	var placeholder: String
	let selectableAction: (() -> Void)

	init(
		title: String,
		option: Binding<Option?>,
		placeholder: String,
		selectableAction: @escaping (() -> Void)
	) {
		self.title = title
		self._option = option
		self.placeholder = placeholder
		self.selectableAction = selectableAction
	}

	var body: some View {
		let text = option == nil ? Text(placeholder).foregroundColor(.gray) : Text(option?.title ?? "")

		VStack(alignment: .leading, spacing: 2) {
			Text(title)
				.bold()
				.font(.subheadline)
			HStack {
				text.padding(.leading, 2)
					.padding(8)
				Spacer()
				Image(systemName: "arrowtriangle.down.fill")
					.padding(.horizontal, 16)
					.foregroundColor(.gray)
			}
			.background {
				RoundedRectangle(cornerRadius: 6)
					.fill(Color(uiColor: .systemGray6))
			}
		}.onTapGesture {
			selectableAction()
		}
	}
}

#Preview {
	DefaultSelectableField<SplitOptions>(
		title: "Title",
		option: .constant(nil),
		placeholder: "Placeholder",
		selectableAction: {}
	)
}
