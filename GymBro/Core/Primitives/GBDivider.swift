import SwiftUI

struct GBDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.borderDefault)
            .frame(height: 1)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        Text("Above divider")
            .font(.bodyMD())
            .foregroundStyle(.labelPrimary)
        GBDivider()
        Text("Below divider")
            .font(.bodyMD())
            .foregroundStyle(.labelPrimary)
    }
    .padding()
    .background(.appBackground)
}
