import SwiftUI

/// Uppercase, tracked section label used to title each Statistics block.
struct StatsSectionHeader: View {
    var title: String

    var body: some View {
        Text(title.uppercased())
            .font(.plusJakartaSans(.semiBold, size: 13))
            .kerning(1)
            .foregroundStyle(.labelSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        StatsSectionHeader(title: "Weekly Volume")
        StatsSectionHeader(title: "Muscle Frequency — This Week")
    }
    .padding()
    .background(.appBackground)
}
