//
//  BigRoundedButtonStyle.swift
import SwiftUI

struct BigRoundedButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
			.font(.buttonTitle())
            .foregroundStyle(.labelOnAccent)
            .padding(.horizontal, 48)
            .padding(.vertical, 18)
            .background(.volt)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == BigRoundedButtonStyle {
    static var bigRounded: BigRoundedButtonStyle { BigRoundedButtonStyle() }
}
