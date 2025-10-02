import SwiftUI

struct DeafaultTextField: View {
	let title: String
	@Binding var text: String
	let keyboardType: UIKeyboardType
	var placeholder: String

	init(title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, placeholder: String) {
		self.title = title
		self._text = text
		self.keyboardType = keyboardType
		self.placeholder = placeholder
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 2) {
			Text(title)
				.bold()
				.font(.subheadline)
			VStack {
				TextField(
					"",
					text: $text,
					prompt: Text(placeholder).foregroundColor(.gray)
				)
				.keyboardType(keyboardType)
				.padding(.leading, 2)
				.padding(8)
			}
			.background {
				RoundedRectangle(cornerRadius: 6)
					.fill(Color(uiColor: .systemGray6))
			}
		}
	}
}

#Preview {
	DeafaultTextField(
		title: "Title",
		text: .constant(
			"Text"
		),
		placeholder: "Placeholder"
	)
}
