import SwiftUI

/// Profile summary — avatar with initials, name, key stats and level pill.
struct ProfileSummaryCard: View {
    let state: ProfileSettingsState

    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.voltDim)
                .frame(width: 64, height: 64)
                .overlay(Circle().stroke(Color.borderSubtle, lineWidth: 1))
                .overlay {
                    Text(state.initials)
                        .font(.barlowCondensed(.bold, size: 26))
                        .foregroundStyle(.volt)
                }

            VStack(alignment: .leading, spacing: 0) {
                Text(state.name)
                    .font(.barlowCondensed(.bold, size: 24))
                    .foregroundStyle(.labelPrimary)

                Text(state.statsLine)
                    .font(.plusJakartaSans(.regular, size: 14))
                    .monospacedDigit()
                    .foregroundStyle(.labelSecondary)
                    .padding(.top, 4)

                Text(state.fitnessLevel.title)
                    .font(.plusJakartaSans(.semiBold, size: 12))
                    .foregroundStyle(.labelSecondary)
                    .padding(.horizontal, 10)
                    .frame(height: 26)
                    .background(Color.chipSurface)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.borderSubtle, lineWidth: 1))
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderSubtle, lineWidth: 1))
        .padding(.horizontal, 20)
        .padding(.top, 14)
    }
}

// MARK: - Preview

#Preview {
    ProfileSummaryCard(state: ProfileSettingsState())
        .background(.appBackground)
}
