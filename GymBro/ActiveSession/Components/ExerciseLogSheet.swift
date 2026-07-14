import SwiftUI

// Volt-tinted surfaces (called out explicitly in the design spec).
private extension Color {
    static let voltSheetBorder = Color(red: 58/255, green: 74/255, blue: 0)   // #3A4A00
    static let voltSheetBg     = Color(red: 20/255, green: 26/255, blue: 0)   // #141A00
}

/// Bottom sheet that hosts set logging. Three body states:
///   • `.active`         — log next set
///   • `.rest`           — countdown timer
///   • `.editing(index)` — edit a previously logged set (active body + highlighted row)
enum LogSheetMode: Equatable {
    case active
    case rest(RestState)
    case editing(Int)
}

struct ExerciseLogSheet: View {
    let exercise: ActiveSessionExercise
    let logged: [LoggedSet]
    let mode: LogSheetMode
    var weightUnit: WeightUnit = .kg

    @Binding var weightInput: String
    @Binding var repsInput: String

    var onClose: () -> Void
    var onLog: () -> Void
    var onSkipRest: () -> Void
    var onTapHistory: (Int) -> Void

    private var editingIndex: Int? {
        if case let .editing(i) = mode { return i }
        return nil
    }

    private var isResting: Bool {
        if case .rest = mode { return true }
        return false
    }

    private var setNumber: Int { logged.count + 1 }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                if case let .rest(rest) = mode {
                    restBody(rest)
                        .padding(.top, 34)
                        .padding(.horizontal, 20)
                } else {
                    activeBody
                        .padding(.top, 16)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 6)
                }
            }

            if !isResting {
                logButton
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
            }

            // Home indicator inset.
            Color.clear.frame(height: 28)
        }
        .background(Color.surfacePrimary)
        .clipShape(RoundedSheetShape(cornerRadius: 24))
        .overlay(
            RoundedSheetShape(cornerRadius: 24)
                .stroke(Color.borderDefault, lineWidth: 1)
        )
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 0) {
            // Drag handle
            Capsule()
                .fill(Color.borderSubtle)
                .frame(width: 36, height: 3)
                .padding(.top, 10)
                .padding(.bottom, 18)

            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(exercise.name)
                        .font(.barlowCondensed(.bold, size: 24))
                        .foregroundStyle(.labelPrimary)
                        .padding(.trailing, 44)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(exercise.subtitle)
                        .font(.plusJakartaSans(.regular, size: 13))
                        .foregroundStyle(.labelSecondary)
                        .padding(.top, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    muscleChips
                        .padding(.top, 12)
                }

                closeButton
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            Rectangle()
                .fill(Color.borderDefault)
                .frame(height: 1)
        }
    }

    private var muscleChips: some View {
        // Single line of chips that wraps in the design — use Flow-like layout.
        HStack(spacing: 6) {
            ForEach(exercise.muscles, id: \.self) { muscle in
                Text(muscle)
                    .font(.plusJakartaSans(.medium, size: 11))
                    .foregroundStyle(.labelSecondary)
                    .padding(.horizontal, 10)
                    .frame(height: 24)
                    .background(Color.surfaceSecondary)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.borderDefault, lineWidth: 1))
            }
            Spacer(minLength: 0)
        }
    }

    private var closeButton: some View {
        Button(action: onClose) {
            Image(systemName: "xmark")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.labelSecondary)
                .frame(width: 32, height: 32)
                .background(Color.surfaceSecondary)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.borderDefault, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .offset(y: -4)
    }

    // MARK: - Active body (States A + D)

    private var activeBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                if let idx = editingIndex {
                    Text("Editing Set \(idx + 1)")
                        .font(.plusJakartaSans(.medium, size: 13))
                        .foregroundStyle(.labelSecondary)
                } else {
                    Text("Set \(setNumber) of \(exercise.sets)")
                        .font(.plusJakartaSans(.medium, size: 13))
                        .foregroundStyle(.labelSecondary)
                }

                Spacer()

                Text("Target \(exercise.repLo)–\(exercise.repHi) reps")
                    .font(.plusJakartaSans(.semiBold, size: 12))
                    .foregroundStyle(Color.volt)
            }

            if !logged.isEmpty {
                VStack(spacing: 6) {
                    ForEach(Array(logged.enumerated()), id: \.offset) { i, set in
                        HistoryRow(
                            number: i + 1,
                            set: set,
                            weightUnit: weightUnit,
                            isEditing: editingIndex == i,
                            onTap: { onTapHistory(i) }
                        )
                    }
                }
                .padding(.top, 14)
            }

            Text(editingIndex != nil ? "EDIT SET \((editingIndex ?? 0) + 1)" : "CURRENT SET")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(1.4)
                .foregroundStyle(.labelTertiary)
                .padding(.top, 20)
                .padding(.bottom, 8)

            HStack(spacing: 12) {
                NumericTile(label: weightUnit.label, value: $weightInput, placeholder: "")
                NumericTile(label: "REPS", value: $repsInput, placeholder: "—")
            }
        }
    }

    // MARK: - Rest body (State B)

    private func restBody(_ rest: RestState) -> some View {
        VStack(spacing: 0) {
            Text("Rest")
                .font(.plusJakartaSans(.medium, size: 12))
                .foregroundStyle(.labelSecondary)

            Text(SessionFormat.mmss(rest.remaining))
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundStyle(Color.volt)
                .tracking(2)
                .padding(.top, 6)
                .padding(.bottom, 4)
                .monospacedDigit()

            Text("Next: Set \(setNumber)")
                .font(.plusJakartaSans(.regular, size: 12))
                .foregroundStyle(.labelTertiary)

            Button(action: onSkipRest) {
                Text("Skip rest")
                    .font(.plusJakartaSans(.semiBold, size: 13))
                    .foregroundStyle(.labelSecondary)
                    .padding(.horizontal, 22)
                    .frame(height: 40)
                    .background(Color.surfaceSecondary)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.borderDefault, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Log / Done button

    private var logButton: some View {
        let editing = editingIndex != nil
        return Button(action: onLog) {
            Text(editing ? "Done editing" : "Log Set")
                .font(.plusJakartaSans(.semiBold, size: 16))
                .foregroundStyle(editing ? Color.labelPrimary : Color.labelOnAccent)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(editing ? Color.surfaceSecondary : Color.volt)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(editing ? Color.borderDefault : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - History row

private struct HistoryRow: View {
    let number: Int
    let set: LoggedSet
    let weightUnit: WeightUnit
    let isEditing: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text("Set \(number)")
                    .font(.plusJakartaSans(.medium, size: 12))
                    .foregroundStyle(.labelSecondary)
                Spacer()
                Text("\(SessionFormat.weight(weightUnit.fromKg(set.kg))) \(weightUnit.rawValue) · \(set.reps) reps")
                    .font(.plusJakartaSans(.semiBold, size: 12))
                    .foregroundStyle(.labelPrimary)
                    .monospacedDigit()
            }
            .padding(.horizontal, 14)
            .frame(height: 38)
            .background(isEditing ? Color.voltSheetBg : Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isEditing ? Color.voltSheetBorder : Color.borderDefault, lineWidth: 1)
            )
            .opacity(isEditing ? 1 : 0.65)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.16), value: isEditing)
    }
}

// MARK: - Numeric tile

private struct NumericTile: View {
    let label: String
    @Binding var value: String
    let placeholder: String

    var body: some View {
        VStack(spacing: 8) {
            TextField(placeholder, text: Binding(
                get: { value },
                set: { value = $0.filter { "0123456789.".contains($0) } }
            ))
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.center)
            .font(.barlowCondensed(.bold, size: 26))
            .foregroundStyle(.labelPrimary)
            .tint(.volt)

            Text(label)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(1.4)
                .foregroundStyle(.labelTertiary)
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.voltSheetBorder, lineWidth: 1)
        )
    }
}

// MARK: - Shape — only top corners rounded

struct RoundedSheetShape: Shape {
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        ).cgPath)
    }
}
