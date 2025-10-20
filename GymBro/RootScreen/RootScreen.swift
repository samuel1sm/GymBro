import SwiftUI

struct RootScreen: View {
	private let dark = Color(.sRGB, red: 0.08, green: 0.09, blue: 0.10, opacity: 1)
	private let darkBlue = Color(.sRGB, red: 0.05, green: 0.22, blue: 0.45, opacity: 1)

	@State var state = RootOptions.login

	var body: some View {
		switch state {
		case .loggedIn: Text("Main Screen")
		case .login:
			ZStack {
				VStack(alignment: .center, spacing: 0) {
					VStack {
						Text("GymBro").foregroundStyle(.white).font(.system(size: 72))
						Spacer()
					}

					VStack(spacing: 32) {
						Button {
						} label: {
							Text("Loggin").font(.title2)
								.frame(width: 240)
						}.buttonStyle(.filledBorderedStyle)

						HStack {
							VStack {
								Divider()
							}
							Text("or")
							VStack {
								Divider()
							}
						}
						Button {
						} label: {
							Text("Create free account").font(.title2)
								.multilineTextAlignment(.center)
								.frame(width: 240)
						}.buttonStyle(.borderedStyle)
					}.padding(.top, 32)
						.padding(.bottom, 60)
						.background(.white)
						.clipShape(
							UnevenRoundedRectangle(
								cornerRadii: .init(
									topLeading: 16,
									bottomLeading: 0,
									bottomTrailing: 0,
									topTrailing: 16
								)
							)
						)
				}.ignoresSafeArea(edges: .bottom)
			}.frame(maxWidth: .infinity)
				.background(
					LinearGradient(
						stops: [
							.init(color: dark, location: 0.0),
							.init(color: darkBlue, location: 0.6),
						],
						startPoint: .top,
						endPoint: .bottom
					)
				)
		}
	}
}

#Preview {
	RootScreen()
}
