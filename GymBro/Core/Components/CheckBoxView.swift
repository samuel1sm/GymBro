import SwiftUI

struct CheckBoxView: View {

	let status: Bool

	var body: some View {
		Image(systemName: status ? "checkmark.square.fill" : "square")
			.foregroundColor(status ? .black : .secondary)
	}
}


#Preview {
	CheckBoxView(status: false)
}
