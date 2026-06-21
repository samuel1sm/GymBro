import SwiftUI

/// Horizontally-scrolling rail of personal-record cards.
struct PersonalRecordsSection: View {
    var records: [PersonalRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            StatsSectionHeader(title: "Personal Records")
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 11) {
                    ForEach(records) { record in
                        PersonalRecordCard(record: record)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 4)
            }
        }
    }
}

/// A single fixed-width PR card: exercise name, record load, and recency.
private struct PersonalRecordCard: View {
    var record: PersonalRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(record.exercise)
                .font(.plusJakartaSans(.medium, size: 13))
                .kerning(-0.1)
                .lineSpacing(1.5)
                .foregroundStyle(.labelPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: 33, alignment: .topLeading)

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text("\(record.kilograms)")
                    .font(.barlowCondensed(.bold, size: 22))
                    .kerning(-0.5)
                    .monospacedDigit()
                Text("kg")
                    .font(.plusJakartaSans(.medium, size: 13))
            }
            .foregroundStyle(.volt)
            .padding(.top, 10)

            Text(record.achieved)
                .font(.plusJakartaSans(.regular, size: 11))
                .foregroundStyle(.labelTertiary)
                .padding(.top, 7)
        }
        .padding(14)
        .frame(width: 124, alignment: .leading)
        .background(.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderDefault, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    VStack {
        PersonalRecordsSection(records: StatisticsState().personalRecords)
        Spacer()
    }
    .background(.appBackground)
}
