import SwiftUI

struct SecondOnboardingView: View {
    @Environment(\.coordinator) private var coordinator
	@Binding var selectedTab: Int

    var body: some View {
		VStack(spacing: 16) {
			HStack {
				Button(action: {
					selectedTab -= 1
				}) {
					Image(systemName: "chevron.left")
						.font(.system(size: 17, weight: .semibold))
						.foregroundStyle(.labelSecondary)
						.padding(8)
				}
				.padding(.leading, 12)

				Spacer()

				Button("Skip") {
					coordinator.push(.profileGoals)
				}.font(.system(size: 15, weight: .medium))
				.foregroundStyle(.labelSecondary)
					.padding(.trailing, 20)
			}
			.frame(height: 44)

			FeatureGraphicView()
				.padding(.vertical, 16)

			VStack(alignment: .leading, spacing: 0) {
				Text("02 · HOW IT WORKS")
					.font(.system(size: 11, weight: .bold, design: .monospaced))
					.tracking(2.4)
					.foregroundStyle(.volt)
					.padding(.bottom, 14)

				let youText = Text("You.").foregroundColor(.volt)
				Text("Built\nAround \(youText)")
					.foregroundColor(.labelPrimary)
					.font(.barlowCondensed(.black, size: 44))
					.lineSpacing(2)

				Text("Tell us your goals, equipment, and schedule. We handle the rest.")
					.font(.system(size: 17))
					.foregroundStyle(.labelSecondary)
					.lineSpacing(5)
					.padding(.top, 14)
				Spacer()
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
        .background(.appBackground)
    }
}

#Preview {
    RouterView {
		SecondOnboardingView(selectedTab: .constant(1))
    }
}
