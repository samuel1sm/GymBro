import SwiftUI

// The `voltDim` asset currently duplicates `volt`, so the dim accent is defined
// locally to match the design spec (#4A5E20).
private extension Color {
    static let voltLowFrequency = Color(red: 74/255, green: 94/255, blue: 32/255)   // #4A5E20
}

/// "Muscle Frequency — This Week": one labeled intensity bar per muscle group.
struct MuscleFrequencySection: View {
    var muscles: [MuscleGroup]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            StatsSectionHeader(title: "Muscle Frequency — This Week")

            VStack(spacing: 14) {
                ForEach(muscles) { muscle in
                    HStack(spacing: 12) {
                        Text(muscle.name)
                            .font(.plusJakartaSans(.medium, size: 12))
                            .kerning(-0.1)
                            .foregroundStyle(.labelSecondary)
                            .frame(width: 70, alignment: .leading)

                        MuscleIntensityBar(
                            fraction: fraction(for: muscle.frequency),
                            color: color(for: muscle.frequency)
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private func fraction(for frequency: MuscleFrequency) -> CGFloat {
        switch frequency {
        case .high:   return 1.0
        case .medium: return 0.62
        case .low:    return 0.30
        case .none:   return 0
        }
    }

    private func color(for frequency: MuscleFrequency) -> Color {
        switch frequency {
        case .high:   return .volt
        case .medium: return .voltMedium
        case .low:    return .voltLowFrequency
        case .none:   return .clear
        }
    }
}

/// A rounded track with a Volt-tinted fill spanning a fraction of its width.
private struct MuscleIntensityBar: View {
    var fraction: CGFloat
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.surfaceSecondary)
                Capsule()
                    .fill(color)
                    .frame(width: geometry.size.width * fraction)
            }
        }
        .frame(height: 8)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        MuscleFrequencySection(muscles: StatisticsState().muscleGroups)
        Spacer()
    }
    .background(.appBackground)
}
