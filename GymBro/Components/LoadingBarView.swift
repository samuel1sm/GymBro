import SwiftUI

struct LoadingBarView<Stage: StageFlow>: View {
	let stage: Stage
	let hasStepCounter: Bool

	@State private var totalWidth: CGFloat = 1
	@State private var loadedWidth: CGFloat = 0.0

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			ZStack(alignment: .leading) {
				GeometryReader { geometry in
					Rectangle()
						.clipShape(.capsule)
						.opacity(0.8)
						.foregroundStyle(.gray)
						.onAppear {
							totalWidth = geometry.size.width
							updateWidth()
						}
						.onChange(of: geometry.size.width) { _, newWidth in
							totalWidth = newWidth
							updateWidth()
						}
				}
				
				Rectangle()
					.clipShape(.capsule)
					.opacity(0.8)
					.foregroundStyle(.black)
					.frame(width: loadedWidth)
					.animation(.easeInOut(duration: 0.35), value: loadedWidth)
			}
			.frame(height: 10)
			.onChange(of: stage) { _, _ in
				updateWidth()
			}
			.onAppear {
				updateWidth()
			}

			if hasStepCounter {
				Text("Step \(stage.rawValue) of \(Stage.allCases.count)")
					.font(.subheadline)
					.foregroundStyle(.gray)
			}
		}
	}

	private func updateWidth() {
		let total = max(CGFloat(Stage.allCases.count), 1)
		loadedWidth = totalWidth / total * CGFloat(stage.rawValue)
	}
}

#Preview {
	LoadingBarView(stage: CustomisationStages.personalInformations, hasStepCounter: true)
}
