import SwiftUI

/// "N of M done" progress label plus the elapsed-time clock, under the nav bar.
struct SessionMetaRow: View {
    let doneCount: Int
    let totalCount: Int
    let elapsedSeconds: Int

    var body: some View {
        HStack {
            Text("\(doneCount) of \(totalCount) done")
                .font(.plusJakartaSans(.medium, size: 13))
                .foregroundStyle(.labelSecondary)

            Spacer()

            HStack(spacing: 6) {
                Image(systemName: "clock")
                    .font(.system(size: 12, weight: .medium))
                Text(SessionFormat.mmss(elapsedSeconds))
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .monospacedDigit()
            }
            .foregroundStyle(.labelSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 12)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        SessionMetaRow(doneCount: 2, totalCount: 6, elapsedSeconds: 754)
        Spacer()
    }
    .background(.appBackground)
}
