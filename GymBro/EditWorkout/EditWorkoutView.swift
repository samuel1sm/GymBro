import SwiftUI

struct EditWorkoutView: View {
    @Environment(\.coordinator) private var coordinator

    @State private var viewModel = EditWorkoutViewModel()
    @State private var exerciseToDelete: EditExercise?
    @State private var isFocusPickerPresented = false
    @State private var isDiscardPresented = false

    var body: some View {
        @Bindable var vm = viewModel

        VStack(spacing: 0) {
            EditWorkoutNavBar(onCancel: cancel, onSave: save)

            List {
                EditSessionHeaderCard(
                    name: sessionNameBinding,
                    focus: viewModel.session.focus,
                    exerciseCount: viewModel.session.exercises.count,
                    estimatedMinutes: viewModel.session.estimatedMinutes,
                    onFocusTap: { isFocusPickerPresented = true }
                )
                .editorRow(insets: EdgeInsets(top: 6, leading: 20, bottom: 0, trailing: 20))

                Text("Exercises")
                    .font(.plusJakartaSans(.semiBold, size: 13))
                    .tracking(1)
                    .foregroundStyle(.labelSecondary)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .editorRow(insets: EdgeInsets(top: 22, leading: 22, bottom: 10, trailing: 22))

                ForEach(viewModel.session.exercises) { exercise in
                    EditExerciseCard(
                        exercise: exercise,
                        isExpanded: viewModel.expandedExerciseID == exercise.id,
                        repsText: repsBinding(for: exercise.id),
                        restText: restBinding(for: exercise.id),
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.toggleExpanded(exercise.id)
                            }
                        },
                        onSwap: { viewModel.fireToast("Exercise Library") },
                        onDelete: { exerciseToDelete = exercise },
                        onStepSets: { viewModel.stepSets(id: exercise.id, by: $0) }
                    )
                    .editorRow(insets: EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20), background: .appBackground)
                }
                .onMove { source, destination in
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
                        viewModel.move(fromOffsets: source, toOffset: destination)
                    }
                }

                AddExerciseButton {
                    viewModel.fireToast("Exercise Library")
                }
                .editorRow(insets: EdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 20))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $exerciseToDelete) { exercise in
            RemoveExerciseSheet(
                exerciseName: exercise.name,
                onConfirm: {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        viewModel.remove(id: exercise.id)
                    }
                    exerciseToDelete = nil
                },
                onCancel: { exerciseToDelete = nil }
            )
        }
        .sheet(isPresented: $isFocusPickerPresented) {
            FocusPickerSheet(
                options: EditWorkoutState.focusOptions,
                current: viewModel.session.focus,
                onPick: { focus in
                    viewModel.setFocus(focus)
                    isFocusPickerPresented = false
                }
            )
        }
        .sheet(isPresented: $isDiscardPresented) {
            DiscardChangesSheet(
                onDiscard: {
                    isDiscardPresented = false
                    coordinator.pop()
                },
                onKeepEditing: { isDiscardPresented = false }
            )
        }
        .overlay(alignment: .bottom) {
            Group {
                if let toastMessage = viewModel.toastMessage {
                    PlannerToast(message: toastMessage)
                        .padding(.bottom, 40)
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.22), value: viewModel.toastMessage)
        }
    }

    // MARK: - Actions

    private func cancel() {
        if viewModel.isDirty {
            isDiscardPresented = true
        } else {
            coordinator.pop()
        }
    }

    private func save() {
        coordinator.pop()
    }

    // MARK: - Bindings

    private var sessionNameBinding: Binding<String> {
        Binding(get: { viewModel.session.name }, set: { viewModel.rename($0) })
    }

    private func repsBinding(for id: EditExercise.ID) -> Binding<String> {
        Binding(
            get: { viewModel.session.exercises.first { $0.id == id }?.reps ?? "" },
            set: { viewModel.updateReps(id: id, $0) }
        )
    }

    private func restBinding(for id: EditExercise.ID) -> Binding<String> {
        Binding(
            get: { viewModel.session.exercises.first { $0.id == id }?.rest ?? "" },
            set: { viewModel.updateRest(id: id, $0) }
        )
    }
}

// MARK: - List row styling

private extension View {
    /// Separator-free row chrome with custom insets. Draggable rows pass an
    /// opaque `appBackground` so the drag-lift snapshot isn't backed by white.
    func editorRow(insets: EdgeInsets, background: Color = .clear) -> some View {
        self
            .listRowInsets(insets)
            .listRowSeparator(.hidden)
            .listRowBackground(background)
    }
}

// MARK: - Preview

#Preview {
    RouterView {
        EditWorkoutView()
    }
}
