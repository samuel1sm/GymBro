import SwiftUI

struct DefaultTextField: View {
	let title: String
	@Binding var text: String
	let keyboardType: UIKeyboardType
	var placeholder: String

	init(
		title: String,
		text: Binding<String>,
		keyboardType: UIKeyboardType = .default,
		placeholder: String
	) {
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
			HStack {
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
	DefaultTextField(
		title: "Title",
		text: .constant(""),
		placeholder: "Placeholder"
	)
}
