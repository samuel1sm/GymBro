import SwiftUI

/// "This Week" progress strip — a row of day dots with focus labels, plus a
/// done / planned session count.
struct WeekStrip: View {
    var week: [WeekDay]
    var doneCount: Int
    var plannedCount: Int

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text("THIS WEEK")
                    .font(.plusJakartaSans(.semiBold, size: 13))
                    .kerning(1)
                    .foregroundStyle(.labelSecondary)
                Spacer()
                HStack(spacing: 0) {
                    Text("\(doneCount)")
                        .font(.plusJakartaSans(.semiBold, size: 13))
                        .monospacedDigit()
                        .foregroundStyle(.volt)
                    Text(" / \(plannedCount) sessions")
                        .font(.plusJakartaSans(.regular, size: 13))
                        .foregroundStyle(.labelSecondary)
                }
            }

            HStack(alignment: .top, spacing: 4) {
                ForEach(week) { day in
                    VStack(spacing: 7) {
                        WeekDayDot(status: day.status)
                        Text(day.letter)
                            .font(.plusJakartaSans(.medium, size: 10))
                            .foregroundStyle(day.status == .today ? Color.labelPrimary : Color.labelTertiary)
                        Text(truncatedFocus(day.focus))
                            .font(.plusJakartaSans(.medium, size: 9))
                            .kerning(-0.1)
                            .foregroundStyle(focusColor(for: day.status))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
    }

    private func truncatedFocus(_ focus: String) -> String {
        focus.count > 6 ? String(focus.prefix(6)) + "…" : focus
    }

    private func focusColor(for status: WeekDayStatus) -> Color {
        switch status {
        case .today: return .volt
        case .done:  return .labelSecondary
        default:     return .labelTertiary   // missed, rest, future — dimmed
        }
    }
}

// MARK: - Day dot

/// A single 30pt status dot in the weekly strip.
struct WeekDayDot: View {
    var status: WeekDayStatus

    private let size: CGFloat = 30

    var body: some View {
        ZStack {
            shape
            symbol
        }
        .frame(width: size, height: size)
    }

    @ViewBuilder
    private var shape: some View {
        switch status {
        case .done:
            Circle().fill(Color.volt)
        case .today:
            Circle().stroke(Color.volt, lineWidth: 2)
        case .missed:
            Circle().stroke(Color.danger, lineWidth: 2)
        case .rest:
            Circle().fill(Color.surfaceSecondary)
        case .future:
            Circle().stroke(Color.borderDefault, lineWidth: 1)
        }
    }

    @ViewBuilder
    private var symbol: some View {
        switch status {
        case .done:
            Image(systemName: "checkmark")
                .font(.system(size: 13, weight: .heavy))
                .foregroundStyle(.labelOnAccent)
        case .missed:
            Image(systemName: "xmark")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.danger)
        default:
            EmptyView()
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        WeekStrip(
            week: [
                WeekDay(letter: "M", status: .done,   focus: "Push"),
                WeekDay(letter: "T", status: .done,   focus: "Pull"),
                WeekDay(letter: "W", status: .missed, focus: "Legs"),
                WeekDay(letter: "T", status: .done,   focus: "Push"),
                WeekDay(letter: "F", status: .today,  focus: "Pull"),
                WeekDay(letter: "S", status: .rest,   focus: "Rest"),
                WeekDay(letter: "S", status: .rest,   focus: "Rest"),
            ],
            doneCount: 3,
            plannedCount: 5
        )
        Spacer()
    }
    .background(.appBackground)
}
