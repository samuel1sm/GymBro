import SwiftUI

struct DeafaultTextField: View {
	let title: String
	@Binding var text: String
	let keyboardType: UIKeyboardType
	var placeholder: String
	let selectableAction: (() -> Void)?

	init(
		title: String,
		text: Binding<String>,
		keyboardType: UIKeyboardType = .default,
		placeholder: String,
		selectableAction: (() -> Void)? = nil
	) {
		self.title = title
		self._text = text
		self.keyboardType = keyboardType
		self.placeholder = placeholder
		self.selectableAction = selectableAction
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 2) {
			Text(title)
				.bold()
				.font(.subheadline)
			HStack {
				TextField(
					"",
					text: $text,
					prompt: Text(placeholder).foregroundColor(.gray)
				)
				.disabled(selectableAction != nil)
				.keyboardType(keyboardType)
				.padding(.leading, 2)
				.padding(8)
				if selectableAction != nil {
					Image(systemName: "arrowtriangle.down.fill")
						.padding(.horizontal, 16)
						.foregroundColor(.gray)
				}
			}
			.background {
				RoundedRectangle(cornerRadius: 6)
					.fill(Color(uiColor: .systemGray6))
			}
		}.onTapGesture {
			selectableAction?()
		}
	}
}

#Preview {
	DeafaultTextField(
		title: "Title",
		text: .constant(""),
		placeholder: "Placeholder",
		selectableAction: nil
	)
}
