import SwiftUI

extension ButtonStyle where Self == FilledBorderedStyle {
	static var filledBorderedStyle: FilledBorderedStyle { FilledBorderedStyle() }
}

extension ButtonStyle where Self == BorderedStyle {
	static var borderedStyle: BorderedStyle { BorderedStyle() }
}

struct FilledBorderedStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.bold()
			.padding()
			.background(configuration.isPressed ? Color.black.opacity(0.7) : Color.black)
			.foregroundStyle(.white)
			.clipShape(RoundedRectangle(cornerRadius: 8))
			.scaleEffect(configuration.isPressed ? 0.98 : 1.0)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}

struct BorderedStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.bold()
			.padding()
			.overlay(
				RoundedRectangle(cornerRadius: 8)
					.stroke(.black)
			)
			.background(
				configuration.isPressed ? Color.gray.opacity(0.7) : Color.clear
			)
			.foregroundStyle(.black)
			.clipShape(RoundedRectangle(cornerRadius: 8))
			.scaleEffect(configuration.isPressed ? 0.98 : 1.0)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}

#Preview {
	VStack {
		Button { } label: {
			Text("Test")
		}.buttonStyle(.filledBorderedStyle)

		Button { } label: {
			Text("Test")
		}.buttonStyle(.borderedStyle)
	}
}
