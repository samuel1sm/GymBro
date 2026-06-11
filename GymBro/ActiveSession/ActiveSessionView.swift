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

                metaRow

                exerciseList
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

    // MARK: - Meta row

    private var metaRow: some View {
        HStack {
            Text("\(viewModel.doneCount) of \(viewModel.exercises.count) done")
                .font(.plusJakartaSans(.medium, size: 13))
                .foregroundStyle(.labelSecondary)

            Spacer()

            HStack(spacing: 6) {
                Image(systemName: "clock")
                    .font(.system(size: 12, weight: .medium))
                Text(SessionFormat.mmss(viewModel.elapsedSeconds))
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .monospacedDigit()
            }
            .foregroundStyle(.labelSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 12)
    }

    // MARK: - Exercise list + end footer

    private var exerciseList: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(Array(viewModel.exercises.enumerated()), id: \.element.id) { index, exercise in
                    ActiveSessionExerciseRow(
                        exercise: exercise,
                        index: index,
                        doneCount: viewModel.logs[index].count,
                        onTap: {
                            withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
                                viewModel.openExerciseSheet(at: index)
                            }
                        }
                    )
                }

                Button(action: { withAnimation { viewModel.requestConfirmEnd() } }) {
                    Text("End session")
                        .font(.plusJakartaSans(.semiBold, size: 13))
                        .foregroundStyle(.labelSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.borderDefault, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .padding(.top, 6)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
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
