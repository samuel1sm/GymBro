import SwiftUI

struct PulsingDots: View {
    @State private var opacities: [Double] = [0.2, 0.2, 0.2]

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.volt)
                    .frame(width: 4, height: 4)
                    .opacity(opacities[i])
            }
        }
        .onAppear {
            for i in 0..<3 {
                withAnimation(
                    .easeInOut(duration: 0.7)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.2)
                ) {
                    opacities[i] = 1.0
                }
            }
        }
    }
}
