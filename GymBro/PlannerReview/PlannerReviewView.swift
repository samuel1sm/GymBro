import SwiftUI

struct PlannerReviewView: View {
    @Environment(\.coordinator) private var coordinator

    @State private var state = PlannerReviewState()
    @State private var activeIndex: Int = 0
    @State private var openedExerciseID: PlannerExercise.ID? = nil
    @State private var toastMessage: String? = nil
    @State private var toastTask: Task<Void, Never>? = nil

    private var activeSlot: PlannerTrainingSlot { state.slots[activeIndex] }
    private var activeExercises: [PlannerExercise] { activeSlot.exercises }

    var body: some View {
        VStack(spacing: 0) {
            header

            PlannerTabStrip(slots: state.slots, activeIndex: tabBinding)

            ScrollView {
                VStack(spacing: 0) {
                    SessionHeaderCard(slot: activeSlot)

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
                        ForEach(Array(activeExercises.enumerated()), id: \.element.id) { index, exercise in
                            PlannerExerciseCard(
                                exercise: exercise,
                                isOpen: openedExerciseID == exercise.id,
                                canMoveUp: index > 0,
                                canMoveDown: index < activeExercises.count - 1,
                                onOpen: { openedExerciseID = exercise.id },
                                onClose: { if openedExerciseID == exercise.id { openedExerciseID = nil } },
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
            if let toastMessage {
                PlannerToast(message: toastMessage)
                    .padding(.bottom, 150)
                    .animation(.easeOut(duration: 0.24), value: toastMessage)
            }
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
                fireToast("Plan saved")
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

    // MARK: - Bindings

    private var tabBinding: Binding<Int> {
        Binding(
            get: { activeIndex },
            set: { newValue in
                activeIndex = newValue
                openedExerciseID = nil
            }
        )
    }

    // MARK: - Mutations

    private func move(from index: Int, by delta: Int) {
        let target = index + delta
        guard state.slots.indices.contains(activeIndex) else { return }
        let exercises = state.slots[activeIndex].exercises
        guard exercises.indices.contains(index), exercises.indices.contains(target) else { return }
        withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
            state.slots[activeIndex].exercises.swapAt(index, target)
        }
    }

    private func remove(at index: Int) {
        guard state.slots.indices.contains(activeIndex),
              state.slots[activeIndex].exercises.indices.contains(index) else { return }
        withAnimation(.easeInOut(duration: 0.22)) {
            state.slots[activeIndex].exercises.remove(at: index)
        }
    }

    // MARK: - Toast

    private func fireToast(_ message: String) {
        toastTask?.cancel()
        withAnimation(.easeOut(duration: 0.22)) {
            toastMessage = message
        }
        toastTask = Task {
            try? await Task.sleep(nanoseconds: 1_800_000_000)
            if !Task.isCancelled {
                await MainActor.run {
                    withAnimation(.easeIn(duration: 0.2)) {
                        toastMessage = nil
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    RouterView {
        PlannerReviewView()
    }
}
