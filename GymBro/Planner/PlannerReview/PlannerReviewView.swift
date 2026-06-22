import SwiftUI

struct PlannerReviewView: View {
    @Environment(\.coordinator) private var coordinator

    @State private var viewModel = PlannerReviewViewModel()
    @State private var exerciseToDelete: PlannerExercise?

    var body: some View {
        @Bindable var vm = viewModel

        VStack(spacing: 0) {
            header

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

            bottomActions
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
