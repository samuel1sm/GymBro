import SwiftUI

struct BorderedOptionView: View {
	let title: String
	let subtitle: String
	@Binding var isOn: Bool
	var fixedHeight: CGFloat?

	init(title: String, subtitle: String, isOn: Binding<Bool>, fixedHeight: CGFloat? = nil) {
		self.title = title
		self.subtitle = subtitle
		self._isOn = isOn
		self.fixedHeight = fixedHeight
	}

	var body: some View {
		HStack(alignment: .center, spacing: 12) {
			VStack(alignment: .leading, spacing: 6) {
				Text(title)
					.font(.title3)
					.fontWeight(.semibold)

				Text(subtitle)
					.font(.subheadline)
					.foregroundStyle(.secondary)
			}

			Spacer()

			CheckBoxView(status: isOn)
		}
		.padding(16)
		.frame(height: fixedHeight)
		.background(
			RoundedRectangle(cornerRadius: 12)
				.fill(Color(.systemBackground))
		)
		.overlay(
			RoundedRectangle(cornerRadius: 12)
				.stroke(Color(.systemGray4), lineWidth: 1)
		)
		.onTapGesture {
			isOn.toggle()
		}
	}
}

#Preview {
	BorderedOptionView(title: "teste", subtitle: "teste", isOn: .constant(true))
}
