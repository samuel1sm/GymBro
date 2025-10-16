import SwiftUI

struct InjuriesAndRestrictionsViews: View {
	@Binding var injuryDescription: String

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			HStack(spacing: 16) {
				Image(systemName: "exclamationmark.circle").frame(width: 16, height: 16)
				Text("Injuries & Restrictions")
				Spacer()
			}

			Text("Describe any injuries or limations").font(.subheadline)

			ZStack(alignment: .topLeading) {
				TextEditor(text: $injuryDescription)
					.frame(height: 100)
					.padding(2)
					.background(Color(uiColor: .systemGray6))
					.cornerRadius(8)
				if injuryDescription.isEmpty {
					Text("E.g., shoulder injury, knee pain, lower back issues...")
						.foregroundColor(.secondary)
						.padding(.horizontal, 8)
						.padding(.vertical, 12)
				}
			}
			Text("This helps us customize your workout plan to avoid aggravating existing injuries")
				.font(.footnote)
				.foregroundColor(.secondary)
		}
	}
}

#Preview {
	InjuriesAndRestrictionsViews(injuryDescription: .constant(""))
}
