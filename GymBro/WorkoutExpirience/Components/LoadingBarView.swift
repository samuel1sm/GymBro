import SwiftUI

struct LoadingBarView<Stage: StageFlow>: View {
	let stage: Stage

	@State private var totalWidth: CGFloat = 1
	@State private var loadedWidth: CGFloat = 0.0

	var body: some View {
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
	}

	private func updateWidth() {
		let total = max(CGFloat(Stage.allCases.count), 1)
		loadedWidth = totalWidth / total * CGFloat(stage.rawValue)
	}
}

#Preview {
	LoadingBarView(stage: CustomisationStages.personalInformations)
}
