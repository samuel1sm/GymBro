import SwiftUI

struct PlannerReviewView: View {
    @Environment(\.coordinator) private var coordinator
    @Environment(\.userStore) private var userStore
    @Environment(\.pendingPlanStore) private var pendingPlanStore

    @State private var viewModel = PlannerReviewViewModel()
    @State private var exerciseToDelete: PlannerExercise?

    /// Persists the pending generated plan to SwiftData, then routes Home.
    private func savePlan() {
        do {
            try pendingPlanStore.persistPlan(to: userStore)
            coordinator.replaceRoot(.main)
        } catch {
            fireToast("Couldn't save your plan")
        }
    }

    var body: some View {
        @Bindable var vm = viewModel

        VStack(spacing: 0) {
            PlannerReviewHeader { coordinator.pop() }

            PlannerTabStrip(slots: viewModel.state.slots, activeIndex: $vm.activeIndex)

            List {
                SessionHeaderCard(slot: viewModel.activeSlot)
                    .plannerRow(insets: EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))

                Text("Exercises")
                    .font(.plusJakartaSans(.semiBold, size: 12))
                    .tracking(1)
                    .foregroundStyle(.labelTertiary)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .plannerRow(insets: EdgeInsets(top: 20, leading: 22, bottom: 10, trailing: 22))

                ForEach(viewModel.activeExercises) { exercise in
                    PlannerExerciseCard(
                        exercise: exercise,
                        onSwap: { fireToast("Swap exercise") },
                        onDelete: { exerciseToDelete = exercise }
                    )
                    .plannerRow(insets: EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20), background: .appBackground)
                }
                .onMove { source, destination in
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
                        viewModel.move(fromOffsets: source, toOffset: destination)
                    }
                }

                AddExerciseCard {
                    fireToast("Exercise Library")
                }
                .plannerRow(insets: EdgeInsets(top: 2, leading: 20, bottom: 8, trailing: 20))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)

            PlannerReviewBottomActions(
                onSave: savePlan,
                onRegenerate: { fireToast("Regenerating…") }
            )
        }
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $exerciseToDelete) { exercise in
            PlannerRemoveExerciseSheet(
                exercise: exercise,
                onConfirm: {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        viewModel.remove(exercise)
                    }
                    exerciseToDelete = nil
                },
                onCancel: { exerciseToDelete = nil }
            )
        }
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

    // MARK: - Helpers

    private func fireToast(_ message: String) {
        viewModel.fireToast(message)
    }
}

// MARK: - List row styling

private extension View {
    /// Applies the planner's separator-free row chrome with custom insets.
    ///
    /// `background` defaults to `clear`, but draggable rows pass `appBackground`
    /// so the system's drag-lift snapshot is opaque (otherwise a clear row falls
    /// back to a white platter behind the lifted card).
    func plannerRow(insets: EdgeInsets, background: Color = .clear) -> some View {
        self
            .listRowInsets(insets)
            .listRowSeparator(.hidden)
            .listRowBackground(background)
    }
}

// MARK: - Preview

#Preview {
    RouterView {
        PlannerReviewView()
    }
}
