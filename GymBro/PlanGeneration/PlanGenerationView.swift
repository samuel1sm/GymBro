import SwiftUI

// MARK: - View

struct PlanGenerationView: View {
	private let steps: [LocalizedStringKey] = [
        "Profile loaded",
        "Equipment validated",
        "Generating weekly structure",
        "Assigning exercises",
        "Adding coaching notes"
    ]

	private let rotatingTexts: [LocalizedStringKey] = [
        "Analysing your goals…",
        "Allocating muscle groups…",
        "Balancing volume and recovery…",
        "Almost ready…"
    ]

    @State private var progress: Double = 0
    @State private var rotatingIndex: Int = 0
    @State private var glowing: Bool = false

    private var activeStepIndex: Int {
        min(steps.count - 1, Int(progress * Double(steps.count)))
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("PLAN GENERATION")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(2.4)
                .foregroundStyle(.volt)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)

            Spacer()

            VStack(spacing: 24) {
                ProgressRingView(progress: progress, glowing: glowing)

                VStack(spacing: 0) {
                    Text("Building Your Plan")
                        .font(.barlowCondensed(.extraBold, size: 32))
                        .foregroundStyle(.labelPrimary)
                        .multilineTextAlignment(.center)

                    ZStack {
                        Text(rotatingTexts[rotatingIndex])
                            .font(.plusJakartaSans(.medium, size: 15))
                            .foregroundStyle(.labelSecondary)
                            .multilineTextAlignment(.center)
                            .id(rotatingIndex)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(y: 6)),
                                removal: .opacity
                            ))
                    }
                    .padding(.top, 10)

                    Text("USUALLY TAKES 10–20 SECONDS")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .tracking(1.4)
                        .foregroundStyle(.labelTertiary)
                        .padding(.top, 8)
                }
            }

            Spacer()

            VStack(alignment: .leading, spacing: 0) {
                ForEach(steps.indices, id: \.self) { i in
                    GenStepRow(
                        label: steps[i],
                        stepState: stepState(for: i)
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderDefault, lineWidth: 1))
			Spacer()
        }
        .padding(.horizontal, 24)
        .background(.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                glowing = true
            }
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 120_000_000)
                guard !Task.isCancelled else { break }
                withAnimation(.linear(duration: 0.12)) {
                    progress += 0.018
                    if progress >= 1.0 { progress = 0 }
                }
            }
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                guard !Task.isCancelled else { break }
                withAnimation(.easeOut(duration: 0.42)) {
                    rotatingIndex = (rotatingIndex + 1) % rotatingTexts.count
                }
            }
        }
    }

    private func stepState(for index: Int) -> GenStepRow.StepState {
        if index < activeStepIndex { return .done }
        if index == activeStepIndex { return .active }
        return .pending
    }
}

// MARK: - Progress Ring

#Preview {
    RouterView {
        PlanGenerationView()
    }
}
