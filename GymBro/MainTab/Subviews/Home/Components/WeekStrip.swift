import SwiftUI

/// Activity progress strip — a card of day status dots with a Week / Month
/// toggle, plus a done / planned session count.
struct WeekStrip: View {
    var week: [WeekDay]
    var month: [MonthDay]
    var monthLabel: String
    var doneCount: Int
    var plannedCount: Int
    var monthDoneCount: Int
    var monthPlannedCount: Int

    @State private var range: ActivityRange = .week

    private let weekdayLetters = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        VStack(spacing: 14) {
            header

            SegmentedPicker(
                options: ActivityRange.allCases.map(\.rawValue),
                selectedIndex: rangeBinding,
                compact: true
            )

            card
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(range == .week ? "THIS WEEK" : "THIS MONTH")
                .font(.plusJakartaSans(.semiBold, size: 13))
                .kerning(1)
                .foregroundStyle(.labelSecondary)
            Spacer()
            HStack(spacing: 0) {
                Text("\(range == .week ? doneCount : monthDoneCount)")
                    .font(.plusJakartaSans(.semiBold, size: 13))
                    .monospacedDigit()
                    .foregroundStyle(.volt)
                Text(" / \(range == .week ? plannedCount : monthPlannedCount) sessions")
                    .font(.plusJakartaSans(.regular, size: 13))
                    .foregroundStyle(.labelSecondary)
            }
        }
    }

    // MARK: - Card

    private var card: some View {
        Group {
            switch range {
            case .week:  weekContent
            case .month: monthContent
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 14)
        .background(.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderDefault, lineWidth: 1))
    }

    // MARK: - Week

    private var weekContent: some View {
        HStack(alignment: .top, spacing: 4) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    WeekDayDot(status: day.status)
                    Text(day.letter)
                        .font(.plusJakartaSans(.semiBold, size: 11))
                        .kerning(0.4)
                        .foregroundStyle(letterColor(for: day.status))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Month

    private var monthContent: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
        return VStack(spacing: 12) {
            Text(monthLabel)
                .font(.plusJakartaSans(.semiBold, size: 12))
                .kerning(0.4)
                .foregroundStyle(.labelTertiary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 6) {
                ForEach(weekdayLetters.indices, id: \.self) { i in
                    Text(weekdayLetters[i])
                        .font(.plusJakartaSans(.medium, size: 10))
                        .foregroundStyle(.labelTertiary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(month) { day in
                    MonthDayCell(day: day)
                }
            }
        }
    }

    // MARK: - Helpers

    private var rangeBinding: Binding<Int> {
        Binding(
            get: { ActivityRange.allCases.firstIndex(of: range) ?? 0 },
            set: { range = ActivityRange.allCases[$0] }
        )
    }

    private func letterColor(for status: WeekDayStatus) -> Color {
        switch status {
        case .today: return .volt
        case .done:  return .labelSecondary
        default:     return .labelTertiary
        }
    }
}

// MARK: - Day dot (week)

/// A single 36pt status dot in the weekly strip.
struct WeekDayDot: View {
    var status: WeekDayStatus

    private let size: CGFloat = 36

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
            Circle().stroke(Color.warning, lineWidth: 2)
        case .rest:
            Circle().fill(Color.surfaceSecondary)
        case .future:
            Circle().fill(Color.surfaceSecondary)
                .overlay(Circle().stroke(Color.borderDefault, lineWidth: 2))
        }
    }

    @ViewBuilder
    private var symbol: some View {
        switch status {
        case .done:
            Image(systemName: "checkmark")
                .font(.system(size: 15, weight: .heavy))
                .foregroundStyle(.labelOnAccent)
        case .missed:
            Image(systemName: "xmark")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.warning)
        case .rest:
            Capsule()
                .fill(Color.labelTertiary)
                .frame(width: 8, height: 2)
        default:
            EmptyView()
        }
    }
}

// MARK: - Day cell (month)

/// A single calendar cell in the monthly grid: a status-tinted circle holding the
/// day-of-month number. Padding cells render empty.
struct MonthDayCell: View {
    var day: MonthDay

    private let size: CGFloat = 32

    var body: some View {
        ZStack {
            if let number = day.number, let status = day.status {
                shape(for: status)
                Text("\(number)")
                    .font(.plusJakartaSans(.semiBold, size: 11))
                    .monospacedDigit()
                    .foregroundStyle(numberColor(for: status))
            }
        }
        .frame(width: size, height: size)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func shape(for status: WeekDayStatus) -> some View {
        switch status {
        case .done:
            Circle().fill(Color.volt)
        case .today:
            Circle().stroke(Color.volt, lineWidth: 2)
        case .missed:
            Circle().stroke(Color.warning, lineWidth: 2)
        case .rest:
            Circle().fill(Color.surfaceSecondary)
        case .future:
            EmptyView()
        }
    }

    private func numberColor(for status: WeekDayStatus) -> Color {
        switch status {
        case .done:   return .labelOnAccent
        case .today:  return .volt
        case .missed: return .warning
        case .rest:   return .labelTertiary
        case .future: return .labelTertiary
        }
    }
}

// MARK: - Preview

#Preview {
    let state = HomeState()
    return VStack {
        WeekStrip(
            week: state.week,
            month: state.month,
            monthLabel: state.monthLabel,
            doneCount: state.doneCount,
            plannedCount: state.plannedCount,
            monthDoneCount: state.monthDoneCount,
            monthPlannedCount: state.monthPlannedCount
        )
        Spacer()
    }
    .background(.appBackground)
}
