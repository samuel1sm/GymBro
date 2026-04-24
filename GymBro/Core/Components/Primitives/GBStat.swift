import SwiftUI

struct GBStat: View {
    var value: String
    var unit: String? = nil
    var label: String
    var color: Color = .labelPrimary

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(value)
                    .font(.barlowCondensed(.black, size: 34))
                    .foregroundStyle(color)
                    .monospacedDigit()
                if let unit {
                    Text(unit)
                        .font(.bodySM())
                        .foregroundStyle(.labelSecondary)
                }
            }
            Text(label.uppercased())
                .font(.micro())
                .kerning(0.8)
                .foregroundStyle(.labelSecondary)
        }
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 20) {
        GBStat(value: "24",  unit: "sets", label: "Volume")
        GBStat(value: "185", unit: "lb",   label: "Top set")
        GBStat(value: "52",  unit: "min",  label: "Duration")
        GBStat(value: "88",  unit: "%",    label: "Effort", color: .volt)
    }
    .padding()
    .background(.appBackground)
}
