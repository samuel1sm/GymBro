import SwiftUI

/// Swipe-left (or long-press) to reveal Up / Down / Remove actions.
/// Trailing swap button stays anchored on the right edge of the foreground card.
struct PlannerExerciseCard: View {
    let exercise: PlannerExercise
    let isOpen: Bool
    let canMoveUp: Bool
    let canMoveDown: Bool
    var onOpen: () -> Void
    var onClose: () -> Void
    var onMoveUp: () -> Void
    var onMoveDown: () -> Void
    var onRemove: () -> Void
    var onSwap: () -> Void

    private static let trayWidth: CGFloat = 168 // 3 × 56
    private static let overdrag: CGFloat = 16

    @State private var dragTranslation: CGFloat = 0
    @GestureState private var isDragging: Bool = false

    private var offset: CGFloat {
        let base: CGFloat = isOpen ? -Self.trayWidth : 0
        let next = base + dragTranslation
        return min(0, max(-Self.trayWidth - Self.overdrag, next))
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            // Action tray (behind)
            HStack(spacing: 0) {
                trayButton(icon: "arrow.up", label: "Up", disabled: !canMoveUp) {
                    onMoveUp(); onClose()
                }
                trayButton(icon: "arrow.down", label: "Down", disabled: !canMoveDown) {
                    onMoveDown(); onClose()
                }
                trayButton(icon: "xmark", label: "Remove", tone: .danger) {
                    onRemove(); onClose()
                }
            }
            .frame(width: Self.trayWidth)
            .frame(maxHeight: .infinity)

            // Foreground card
            foreground
                .offset(x: offset)
                .animation(isDragging ? nil : .spring(response: 0.32, dampingFraction: 0.82), value: offset)
                .gesture(dragGesture)
                .gesture(longPressGesture)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: Foreground card

    private var foreground: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                Text(exercise.name)
                    .font(.plusJakartaSans(.medium, size: 17))
                    .foregroundStyle(.labelPrimary)
                    .lineLimit(1)

                Text(exercise.muscles)
                    .font(.plusJakartaSans(.regular, size: 14))
                    .foregroundStyle(.labelSecondary)
                    .padding(.top, 3)

                HStack(spacing: 6) {
                    PlannerSpecChip {
                        Text("\(exercise.sets) × \(exercise.reps)")
                    }
                    PlannerSpecChip {
                        Image(systemName: "timer")
                            .font(.system(size: 11, weight: .medium))
                        Text("\(exercise.restSeconds)s rest")
                    }
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onSwap) {
                Image(systemName: "arrow.2.squarepath")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.labelTertiary)
                    .frame(width: 40, height: 40)
                    .background(Color.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.borderDefault, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderSubtle, lineWidth: 1))
    }

    // MARK: Tray button

    private enum Tone { case neutral, danger }

    @ViewBuilder
    private func trayButton(icon: String, label: String, disabled: Bool = false, tone: Tone = .neutral, action: @escaping () -> Void) -> some View {
        let fg: Color = disabled ? .labelTertiary : (tone == .danger ? .danger : .labelPrimary)
        let bg: Color = tone == .danger ? Color.danger.opacity(0.14) : Color.surfaceSecondary

        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .semibold))
                Text(label)
                    .font(.plusJakartaSans(.semiBold, size: 11))
            }
            .foregroundStyle(fg)
            .frame(width: 56)
            .frame(maxHeight: .infinity)
            .background(bg)
            .opacity(disabled ? 0.4 : 1)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }

    // MARK: Gestures

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 6)
            .updating($isDragging) { _, state, _ in state = true }
            .onChanged { value in
                dragTranslation = value.translation.width
            }
            .onEnded { value in
                let base: CGFloat = isOpen ? -Self.trayWidth : 0
                let final = base + value.translation.width
                dragTranslation = 0
                if final < -Self.trayWidth / 2 {
                    if !isOpen { onOpen() }
                } else {
                    if isOpen { onClose() }
                }
            }
    }

    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.45)
            .onEnded { _ in
                if !isOpen { onOpen() }
            }
    }
}
