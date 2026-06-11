import SwiftUI

struct PlannerReviewView: View {
    @Environment(\.coordinator) private var coordinator

    @State private var viewModel = PlannerReviewViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        VStack(spacing: 0) {
            header

            PlannerTabStrip(slots: viewModel.state.slots, activeIndex: $vm.activeIndex)

            ScrollView {
                VStack(spacing: 0) {
                    SessionHeaderCard(slot: viewModel.activeSlot)

                    Text("Exercises")
                        .font(.plusJakartaSans(.semiBold, size: 12))
                        .tracking(1)
                        .foregroundStyle(.labelTertiary)
                        .textCase(.uppercase)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 2)
                        .padding(.top, 20)
                        .padding(.bottom, 10)

                    LazyVStack(spacing: 10) {
                        ForEach(Array(viewModel.activeExercises.enumerated()), id: \.element.id) { index, exercise in
                            PlannerExerciseCard(
                                exercise: exercise,
                                isOpen: viewModel.openedExerciseID == exercise.id,
                                canMoveUp: index > 0,
                                canMoveDown: index < viewModel.activeExercises.count - 1,
                                onOpen: { viewModel.openExercise(exercise.id) },
                                onClose: { viewModel.closeExercise(exercise.id) },
                                onMoveUp: { move(from: index, by: -1) },
                                onMoveDown: { move(from: index, by: +1) },
                                onRemove: { remove(at: index) },
                                onSwap: { fireToast("Swap exercise") }
                            )
                        }

                        AddExerciseCard {
                            fireToast("Exercise Library")
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)
            }
            .scrollDismissesKeyboard(.interactively)

            bottomActions
        }
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .bottom) {
            Group {
                if let toastMessage = viewModel.toastMessage {
                    PlannerToast(message: toastMessage)
                        .padding(.bottom, 150)
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.22), value: viewModel.toastMessage)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.labelPrimary)
                        .padding(8)
                }
                .buttonStyle(.plain)

                Spacer()

                Text("REVIEW PLAN")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .tracking(1.6)
                    .foregroundStyle(.labelSecondary)

                Spacer()

                Color.clear.frame(width: 36, height: 36)
            }
            .frame(height: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text("Your Week")
                    .font(.barlowCondensed(.bold, size: 32))
                    .foregroundStyle(.labelPrimary)

                Text("Review each session, swap or reorder exercises, then save.")
                    .font(.plusJakartaSans(.medium, size: 14))
                    .foregroundStyle(.labelSecondary)
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, 20)
        .padding(.top, 2)
        .padding(.bottom, 14)
    }

    // MARK: - Bottom actions

    private var bottomActions: some View {
        VStack(spacing: 10) {
            GBButton(
                label: "Save Plan",
                variant: .primary,
                size: .lg,
                isFullWidth: true
            ) {
                coordinator.push(.activeSession)
            }

            GBButton(
                label: "Regenerate",
                variant: .secondary,
                size: .lg,
                icon: "bolt.fill",
                isFullWidth: true
            ) {
                fireToast("Regenerating…")
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 14)
        .background(
            Color.appBackground
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Color.borderDefault)
                        .frame(height: 1)
                }
		)
    }

    // MARK: - Animated wrappers

    private func move(from index: Int, by delta: Int) {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
            viewModel.move(from: index, by: delta)
        }
    }

    private func remove(at index: Int) {
        withAnimation(.easeInOut(duration: 0.22)) {
            viewModel.remove(at: index)
        }
    }

    private func fireToast(_ message: String) {
        viewModel.fireToast(message)
    }
}

// MARK: - Preview

#Preview {
    RouterView {
        PlannerReviewView()
    }
}
