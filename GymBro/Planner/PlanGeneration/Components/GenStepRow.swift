import SwiftUI

struct GenStepRow: View {
    enum StepState { case done, active, pending }

    let label: LocalizedStringKey
    let stepState: StepState

    @State private var pulsing = false

    var body: some View {
        HStack(spacing: 12) {
            indicator

            HStack(spacing: 4) {
                Text(label)
                    .font(.plusJakartaSans(stepState == .active ? .semiBold : .medium, size: 15))
                    .foregroundStyle(textColor)

                if stepState == .active {
					PulsingDots()
				}
            }
        }
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var indicator: some View {
        ZStack {
            Circle()
                .fill(stepState == .done ? Color.volt : Color.clear)
                .frame(width: 22, height: 22)

            Circle()
                .strokeBorder(
                    stepState == .pending ? Color.borderDefault : Color.volt,
                    lineWidth: 1.5
                )
                .frame(width: 22, height: 22)

            if stepState == .done {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.labelOnAccent)
            } else if stepState == .active {
                Circle()
                    .fill(Color.volt)
                    .frame(width: 8, height: 8)
                    .scaleEffect(pulsing ? 1.15 : 0.85)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                            pulsing = true
                        }
                    }
            }
        }
        .frame(width: 22, height: 22)
    }

    private var textColor: Color {
        switch stepState {
        case .done:    return .labelSecondary
        case .active:  return .labelPrimary
        case .pending: return .labelTertiary
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: 0) {
        GenStepRow(label: "Analyzing your profile", stepState: .done)
        GenStepRow(label: "Selecting exercises", stepState: .active)
        GenStepRow(label: "Balancing weekly volume", stepState: .pending)
    }
    .padding(24)
    .background(.appBackground)
}
