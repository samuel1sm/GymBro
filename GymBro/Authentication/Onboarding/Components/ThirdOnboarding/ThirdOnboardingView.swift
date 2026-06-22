import SwiftUI

struct ThirdOnboardingView: View {
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
				Spacer()
			}
			.frame(height: 44)

			CTAGraphicView()
				.padding(.vertical, 16)

			VStack(alignment: .leading, spacing: 0) {
				Text("03 · LET'S GO")
					.font(.system(size: 11, weight: .bold, design: .monospaced))
					.tracking(2.4)
					.foregroundStyle(.volt)
					.padding(.bottom, 14)

				let smarterText = Text("smarter?").foregroundColor(.volt)
				Text("Ready to train\n\(smarterText)")
					.foregroundColor(.labelPrimary)
					.font(.barlowCondensed(.black, size: 44))
					.lineSpacing(2)

				Text("Set up your profile and generate your first plan — it takes less than 3 minutes.")
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
		ThirdOnboardingView(selectedTab: .constant(2))
	}
}
