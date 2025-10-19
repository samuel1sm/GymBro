import SwiftUI

struct HealthIntegrationView: View {
	@Binding var isAppleHealthCareEnable: Bool
	@Binding var isGoogleFitEnable: Bool

	var body: some View {
		VStack(spacing: 16) {
			HStack(spacing: 16) {
				Image(systemName: "heart.text.clipboard.fill").frame(width: 16, height: 16)
				Text("Health integration")
				Spacer()
			}

			Text("Connect with health platforms to track your activity, calories, heart rate, and more.")
				.font(.subheadline).foregroundStyle(Color(UIColor.darkGray))
				.padding(.bottom, 4)

			BorderedOptionView(
				title: "Apple Health",
				subtitle: "Track steps, workouts, heart rate zones",
				isOn: $isAppleHealthCareEnable,
				fixedHeight: 100
			)

			BorderedOptionView(
				title: "Google Fit",
				subtitle: "Sync activity data, calories, pace",
				isOn: $isGoogleFitEnable,
				fixedHeight: 100
			)
		}
	}
}

#Preview {
	HealthIntegrationView(
		isAppleHealthCareEnable: .constant(
			true
		),
		isGoogleFitEnable: .constant(
			false
		)
	)
}
