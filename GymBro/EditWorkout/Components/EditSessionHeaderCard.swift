import SwiftUI

/// Header card for the Edit Workout screen: an editable session name, a tappable
/// Volt focus pill, and an exercise-count / duration meta line.
struct EditSessionHeaderCard: View {
    @Binding var name: String
    let focus: String
    let exerciseCount: Int
    let estimatedMinutes: Int
    var onFocusTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 10) {
                TextField("Session name", text: $name)
                    .font(.barlowCondensed(.bold, size: 22))
                    .foregroundStyle(.labelPrimary)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .frame(maxWidth: .infinity, alignment: .leading)

                focusPill
            }

            Text("\(exerciseCount) \(exerciseCount == 1 ? "exercise" : "exercises") · ~\(estimatedMinutes) min")
                .font(.plusJakartaSans(.medium, size: 12))
                .foregroundStyle(.labelSecondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderSubtle, lineWidth: 1))
    }

    private var focusPill: some View {
        Button(action: onFocusTap) {
            HStack(spacing: 4) {
                Text(focus)
                    .font(.plusJakartaSans(.bold, size: 11))
                    .kerning(0.1)
                Image(systemName: "chevron.down")
                    .font(.system(size: 9, weight: .heavy))
            }
            .foregroundStyle(.volt)
            .frame(height: 24)
            .padding(.leading, 10)
            .padding(.trailing, 8)
            .background(.planTileBackground)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.planChipBorder, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .fixedSize()
    }
}

#Preview {
    EditSessionHeaderCard(
        name: .constant("Training 1"),
        focus: "Push",
        exerciseCount: 5,
        estimatedMinutes: 58,
        onFocusTap: {}
    )
    .padding(20)
    .background(.appBackground)
}
