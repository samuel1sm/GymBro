import SwiftUI

/// 18pt ring with a transparent top, spinning continuously — matches the
/// prototype's loading indicator on the auth CTAs.
struct AuthSpinner: View {
    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(Color.labelOnAccent, style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .frame(width: 18, height: 18)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 0.72).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

// MARK: - Preview

#Preview {
    AuthSpinner()
        .padding(24)
        .background(.volt)
}
