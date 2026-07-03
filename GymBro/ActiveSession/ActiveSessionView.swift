import SwiftUI

/// Screen 06 — Active Workout Session (two-layer architecture).
///
/// Layer 1: persistent session overview list (nav + meta row + exercise rows + end footer).
/// Layer 2: full-screen bottom sheet per exercise with set-logging body states
///          A (active set), B (rest timer), C (auto-dismiss after last set), D (edit).
struct ActiveSessionView: View {
    @Environment(\.coordinator) private var coordinator
    @State private var viewModel = ActiveSessionViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                ActiveSessionNavBar(
                    split: viewModel.split,
                    day: viewModel.day,
                    onBack: { viewModel.handleBack(pop: coordinator.pop) },
                    onMore: { /* placeholder */ }
                )

                SessionMetaRow(
                    doneCount: viewModel.doneCount,
                    totalCount: viewModel.exercises.count,
                    elapsedSeconds: viewModel.elapsedSeconds
                )

                ActiveSessionExerciseList(
                    exercises: viewModel.exercises,
                    doneCounts: viewModel.logs.map(\.count),
                    onTapExercise: { index in
                        withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
                            viewModel.openExerciseSheet(at: index)
                        }
                    },
                    onEndSession: { withAnimation { viewModel.requestConfirmEnd() } }
                )
            }

            // Layer 2 — exercise sheet
            if viewModel.openIndex != nil, let exercise = viewModel.openExercise {
                sheetOverlay {
                    ExerciseLogSheet(
                        exercise: exercise,
                        logged: viewModel.openLogs,
                        mode: viewModel.currentMode,
                        weightInput: $vm.weightInput,
                        repsInput: $vm.repsInput,
                        onClose: { withAnimation(.easeIn(duration: 0.22)) { viewModel.closeSheet() } },
                        onLog: { viewModel.logSet() },
                        onSkipRest: { viewModel.endRest() },
                        onTapHistory: { viewModel.tapHistory($0) }
                    )
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }

            // Confirm sheet
            if viewModel.isConfirmingEnd {
                sheetOverlay {
                    EndSessionConfirmSheet(
                        onResume: { withAnimation(.easeOut(duration: 0.2)) { viewModel.resumeFromConfirm() } },
                        onEnd: { withAnimation(.easeOut(duration: 0.22)) { viewModel.endSession(pop: coordinator.pop) } }
                    )
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(3)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .animation(.spring(response: 0.34, dampingFraction: 0.86), value: viewModel.openIndex)
        .animation(.spring(response: 0.34, dampingFraction: 0.86), value: viewModel.isConfirmingEnd)
        .onAppear { viewModel.startClock() }
        .onDisappear { viewModel.stopClock() }
    }

    // MARK: - Sheet overlay

    @ViewBuilder
    private func sheetOverlay<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .transition(.opacity)
            content()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Preview

#Preview {
    RouterView {
        ActiveSessionView()
    }
}
